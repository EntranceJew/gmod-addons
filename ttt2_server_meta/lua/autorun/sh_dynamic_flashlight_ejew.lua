require("niknaks")
DFLASH = DFLASH or {}
---@type { [number]: PlayerCache }
DFLASH.cache = DFLASH.cache or {}
DFLASH.light_cache = DFLASH.light_cache or {}
DFLASH.snap_buff = DFLASH.snap_buff or {}

---@class FlashSettings
DFLASH.default_flash_settings = {
	---@class ProjectedTextureSnapshot
	snap = {
		Brightness = 1,
		FarZ = 900,
		NearZ = 1,
		EnableShadows = false,
		Texture = "effects/flashlight001",
		Color = Color(255, 255, 255, 255),
		FOV = 50,
	},
	-- non-ProjectedTexture settings:
	adapt_fov = false,

	---might cause some ugly flickering, but prevents light from bleeding through walls
	adapt_farz = false,
	adapt_nearz = false,
	set_target = false,
	max_farz = 2048,

	use_role_color = false,
	use_interval = false,
	update_interval = 0,
	hull_mult = 1,
	pos_tol = 0.02,
	hit_tol = 1,
	use_default_effect = false,
}

-- @TODO:
-- ply:AddEffects(EF_NOFLASHLIGHT)
-- ply:AddEffects(EF_NORECEIVESHADOW)
-- ply:AddEffects(EF_NOSHADOW)

---@type ProjectedTextureSnapshot
DFLASH.off_snapshot = {
	-- we have to kill the brightness to prevent some issue with HDR bleeding
	-- lightmaps onto itself or some shit, which i sadly couldn't find an exploit
	-- to reduce the amount of lights used by cycling them
	Brightness = 0,
	FarZ = 0,
	NearZ = 0,
	EnableShadows = false,
}

DFLASH.settings = {
	debug = {
		bot_nw2var = true,
		default_pt = true,
		print = false,
	},
	ahead = 20,
	light_pos = Vector(0, 0, 40),
	flash_noise = true,

	---@as FlashSettings
	first = table.Copy(DFLASH.default_flash_settings),
	---@as FlashSettings
	third = table.Copy(DFLASH.default_flash_settings),
}
-- firstperson overlaps
DFLASH.settings.first.adapt_fov = true
--- allow the light to begin inside our eyes
DFLASH.settings.first.hull_mult = 0
--- only the client can get an expensive flashlight
DFLASH.settings.first.update_interval = 0
DFLASH.settings.first.snap.EnableShadows = true
DFLASH.settings.first.snap.NearZ = 16
DFLASH.settings.first.snap.Brightness = 1
-- thirdperson overlaps
DFLASH.settings.third.adapt_farz = true
DFLASH.settings.third.adapt_nearz = false
DFLASH.settings.third.set_target = false
DFLASH.settings.third.use_interval = true
DFLASH.settings.third.use_role_color = false
DFLASH.settings.third.update_interval = 1 / 15
-- DFLASH.settings.third.snap.Color = Color(255, 0, 0, 255)
DFLASH.settings.third.snap.FarZ = 300

-- globals for speed (racing stripes)
local world = game.GetWorld()

local dprint = function(...)
	if DFLASH.settings.debug.print then
		print("DFLASH:", ...)
	end
end


---Apply light settings.
---@param pt ProjectedTexture
---@param snap ProjectedTextureSnapshot
local function ApplyProjectedTextureSnapshot(pt, snap)
	for snap_key, snap_value in pairs(snap) do
		if snap_value ~= nil then
			dprint("snap_key", "Set" .. snap_key)
			pt["Set" .. snap_key](pt, snap_value)
		end
	end
end

local function PlayerHullRadius(ply)
	local hull = ply:Crouching() and {ply:GetHullDuck()} or {ply:GetHull()}
	local b, t = hull[1], hull[2]
	local o = t - b
	return (o.x + o.y) / 2
end

local function Living(ply)
	return IsValid(ply) and ply:Alive() and ply:IsActive() and not ply:IsSpec()
end

---comment
---@param pt ProjectedTexture
---@return ProjectedTextureSnapshot
local function CreateSnapshot(pt)
	return {
		Angles = pt:GetAngles(),
		Brightness = pt:GetBrightness(),
		Color = pt:GetColor(),
		ConstantAttenuation = pt:GetConstantAttenuation(),
		EnableShadows = pt:GetEnableShadows(),
		FarZ = pt:GetFarZ(),
		HorizontalFOV = pt:GetHorizontalFOV(),
		LightWorld = pt:GetLightWorld(),
		LinearAttenuation = pt:GetLinearAttenuation(),
		NearZ = pt:GetNearZ(),
		Orthographic = pt:GetOrthographic(),
		Pos = pt:GetPos(),
		QuadraticAttenuation = pt:GetQuadraticAttenuation(),
		ShadowDepthBias = pt:GetShadowDepthBias(),
		ShadowFilter = pt:GetShadowFilter(),
		ShadowSlopeScaleDepthBias = pt:GetShadowSlopeScaleDepthBias(),
		TargetEntity = pt:GetTargetEntity(),
		Texture = pt:GetTexture(),
		TextureFrame = pt:GetTextureFrame(),
		VerticalFOV = pt:GetVerticalFOV(),
	}
end

---comment
---@param flash_settings (FlashSettings|nil)
---@return ProjectedTexture
local function RemakeLight(flash_settings)
	flash_settings = table.Merge(table.Copy(flash_settings or DFLASH.default_flash_settings), DFLASH.off_snapshot) --[[@as FlashSettings]]
	-- local pt = ents.CreateClientside("xalphox_projectedtexture")
	-- pt:Initialize()
	-- pt:Think()
	local pt = ProjectedTexture()
	if DFLASH.settings.debug.default_pt then
		PrintTable(CreateSnapshot(pt))
	end
	ApplyProjectedTextureSnapshot(pt, flash_settings.snap)

	-- ensure it starts disabled
	pt:Update()
	return pt
end

local function GetPlayerColor(ply)
	local client = LocalPlayer()
	local rd = ply:GetSubRoleData()
	local should_draw = ply:IsActive()
		and ply:HasRole()
		and (not client:IsActive() or ply:IsInTeam(client) or rd.isPublicRole)
		and not rd.avoidTeamIcons
	local _, _, color_hook = hook.Run("TTT2ModifyOverheadIcon", ply, should_draw)
	return color_hook or ply:GetRoleColor() or COLOR_WHITE --or COLOR_SLATEGRAY
end

---comment
---@param ply Player
---@return PlayerCache
local function CachePlayer(ply)
	local new_tra = ply:GetEyeTrace()
	---@class PlayerCache
	---@field pt ProjectedTexture
	---@field was_on boolean
	---@field cur number Last time the update interval ran.
	local p = {
		eye = ply:EyeAngles(),
		pos = new_tra.StartPos,
		hit = new_tra.HitPos,
		ent = new_tra.Entity == world and NULL or new_tra.Entity,
		clr = GetPlayerColor(ply),
	}
	return p
end

---comment
---@param pid number
---@param ply Player
---@param flash_settings FlashSettings
---@return PlayerCache
local function FirstCachePlayer(pid, ply, flash_settings)
	local p = CachePlayer(ply)
	p.cur = CurTime()
	DFLASH.cache[pid] = p
	DFLASH.light_cache[pid] = RemakeLight(flash_settings)
	return p
end

DFLASH.Think = function()
	local PVS = NikNaks.PVS()
	local l_ply = LocalPlayer()
	for pid, ply in ipairs(player.GetAll()) do
		local player_override = (DFLASH.settings.debug.bot_nw2var and l_ply or ply)
		local is_first = ply == l_ply
		local flash_settings = DFLASH.settings[is_first and "first" or "third"] --[[@as FlashSettings]]
		local flash_snap = flash_settings.snap
		local should_update = false
		local force_full = false
		local cache = DFLASH.cache[pid]
		local pt = DFLASH.light_cache[pid]
		-- pre-allocate the projected textures
		if not cache or not pt then
			cache = FirstCachePlayer(pid, ply, flash_settings)
			pt = DFLASH.light_cache[pid]
			should_update = true
			return
		end
		local new_cache = table.Inherit(CachePlayer(ply), cache)

		---@type ProjectedTextureSnapshot
		local NewSnap = DFLASH.snap_buff[pid] or {}

		local time_gate = true
		if flash_settings.use_interval then
			time_gate = (CurTime() >= new_cache.cur + flash_settings.update_interval)
		end
		-- did global visibility change?
		local should_be_on = (
			(PVS:TestPosition(new_cache.pos) or PVS:TestPosition(new_cache.hit))
			and player_override:GetNW2Bool("DFLASH_ON", false)
			and Living(ply)
		)
		new_cache.was_on = should_be_on --[[@as boolean]]

		if should_be_on and not cache.was_on then
			dprint("light on", ply)
			table.Merge(NewSnap, flash_snap)
			if flash_settings.use_default_effect then
				ply:AddEffects(EF_DIMLIGHT)
			end
			force_full = true
		end

		if cache.was_on and not should_be_on then
			dprint("light off", ply)
			table.Merge(NewSnap, DFLASH.off_snapshot)
			if flash_settings.use_default_effect then
				ply:AddEffects(EF_DIMLIGHT)
			end
			force_full = true
		end

		if force_full or should_be_on then
			if flash_settings.use_role_color and (force_full or new_cache.clr ~= pt:GetColor()) then
				NewSnap.Color = new_cache.clr
			end
			if force_full or pt:GetEnableShadows() ~= flash_snap.EnableShadows then
				NewSnap.EnableShadows = flash_snap.EnableShadows
			end
			local eye_moved = new_cache.eye ~= cache.eye
			if force_full or eye_moved then
				NewSnap.Angles = new_cache.eye
			end
			-- ALSO update the Position every time the Angle changes so it doesn't bend all weird
			if force_full or eye_moved or (not new_cache.pos:IsEqualTol(cache.pos, flash_settings.pos_tol)) then
				NewSnap.Pos = new_cache.pos + (new_cache.eye:Forward() * ( PlayerHullRadius(ply) * flash_settings.hull_mult ))
			end
			if flash_settings.adapt_farz and (force_full or not new_cache.hit:IsEqualTol(cache.hit, flash_settings.hit_tol)) then
				NewSnap.FarZ = math.min(new_cache.pos:Distance( new_cache.hit ), flash_settings.max_farz)
			end
			if flash_settings.adapt_nearz and (force_full or pt:GetNearZ() ~= PlayerHullRadius(ply)) then
				NewSnap.NearZ = PlayerHullRadius(ply)
			end
			if flash_settings.adapt_fov and (force_full or (ply:GetFOV() ~= pt:GetHorizontalFOV() or ply:GetFOV() ~= pt:GetVerticalFOV())) then
				NewSnap.FOV = ply:GetFOV()
			end
			if flash_settings.set_target and (force_full or (new_cache.ent ~= cache.ent)) then
				NewSnap.TargetEntity = new_cache.ent
			end
		end

		if force_full or time_gate then
			for _, _ in pairs(NewSnap) do
				ApplyProjectedTextureSnapshot(pt, NewSnap)
				should_update = true
				break
			end
			new_cache.cur = CurTime()
			DFLASH.snap_buff[pid] = {}
		end

		if should_update then
			pt:Update()
		end

		DFLASH.cache[pid] = new_cache
	end
end


DFLASH.PlayerSwitchFlashlight = function(ply, state)
	local isAlive = Living(ply)
	if isAlive and DFLASH.settings.flash_noise then
		ply:EmitSound("HL2Player.FlashLightOn")
	end

	ply:SetNW2Bool("DFLASH_ON", not ply:GetNW2Bool("DFLASH_ON", false))
	-- ply:SetNW2Bool("DFLASH_ON", isAlive and (not ply:GetNW2Bool("DFLASH_ON", false)) or false)

	return false
end

if CLIENT then
	hook.Remove("Think", "DFLASH.Think")
	hook.Add("Think", "DFLASH.Think", DFLASH.Think)
else
	hook.Remove("PlayerSwitchFlashlight", "DFLASH.PlayerSwitchFlashlight")
	hook.Add("PlayerSwitchFlashlight", "DFLASH.PlayerSwitchFlashlight", DFLASH.PlayerSwitchFlashlight)
end
