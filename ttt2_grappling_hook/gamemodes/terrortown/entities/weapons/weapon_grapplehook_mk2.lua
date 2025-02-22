AddCSLuaFile()

CreateConVar("grapple_distance", -1, bit.bor(FCVAR_GAMEDLL, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE),"max distance which its allowed to fire")
CreateConVar("grapple_latch_speed", 5000, bit.bor(FCVAR_GAMEDLL, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE),"speed at which the rope flies to its target")
CreateConVar("grapple_speed_mk2", 1000, bit.bor(FCVAR_GAMEDLL, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE),"speed at which the player gets pulled to the destination")
CreateConVar("grapple_damage_min", 15, bit.bor(FCVAR_GAMEDLL, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE),"how much damage should it do minimal to hooked objects")
CreateConVar("grapple_damage_max", 25, bit.bor(FCVAR_GAMEDLL, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE),"how much damage should it do maximal to hooked objects")
CreateConVar("grapple_damage_enable", 1, bit.bor(FCVAR_GAMEDLL, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE),"should hooked objects take damage?")
CreateConVar("grapple_play_sounds", 1, bit.bor(FCVAR_GAMEDLL, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE),"should hooked objects and the weapon make sounds?")
CreateConVar("grapple_ignore_sky", 1, bit.bor(FCVAR_GAMEDLL, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE),"can the grapple hook onto the sky?")

if CLIENT then
	SWEP.DrawWeaponInfoBox	= false
	SWEP.BounceWeaponIcon	= false

	killicon.Add("weapon_grapplehook_mk2","effects/killicons/weapon_grapplehook",Color(255,255,255))
	SWEP.WepSelectIcon	= surface.GetTextureID("hud/swepicons/weapon_grapplehook/icon")

	SWEP.Icon = "vgui/ttt/icon_shotgun"
end

SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_SHOTGUN
SWEP.builtin = true
SWEP.spawnType = WEAPON_TYPE_SHOTGUN

SWEP.Base			= "weapon_tttbase"
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= "A Grappling Hook"
SWEP.Instructions	= "Left click to fire"

SWEP.Category			= "Team Fortress 2"
SWEP.PrintName			= "Grappling Hook MK2"
SWEP.Kind				= WEAPON_EQUIP
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.HoldType			= "pistol"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.AdminOnly          = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

local sndGrappleHit		= Sound("weapons/grappling_hook_impact_default.wav")
local sndGrappleHitFlesh= Sound("weapons/grappling_hook_impact_flesh.wav")
local sndGrappleShoot	= Sound("weapons/grappling_hook_shoot.wav")
local sndGrappleReel	= Sound("weapons/grappling_hook_reel_start.wav")
local sndGrappleAbort	= Sound("weapons/grappling_hook_reel_stop.wav")

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(9.892, -0.811, 2.532), angle = Angle(-10.782, -7.685, 14.444) },
	["ValveBiped.square"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.clip"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -30), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["v_element"] = { type = "Model", model = "models/weapons/c_models/c_grappling_hook/c_grappling_hook.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.032, 1.476, -1.58), angle = Angle(0, 0, 177.921), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["v_element2"] = { type = "Model", model = "models/props_c17/pulleywheels_large01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.571, 3.808, -1.502), angle = Angle(-1.657, 89.515, 0), size = Vector(0.09, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "mm_materials/zinc01_low2", skin = 0, bodygroup = {} },
	["v_element3"] = { type = "Model", model = "models/props_c17/pulleywheels_large01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.571, 3.808, -1.502), angle = Angle(-1.657, 89.515, 45), size = Vector(0.09, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "mm_materials/zinc01_low2", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_element"] = { type = "Model", model = "models/weapons/c_models/c_grappling_hook/c_grappling_hook.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.709, 1.886, -2), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Initialize()
	nextshottime = CurTime()
	self:SetHoldType(self.HoldType)
	self:SetWeaponHoldType(self.HoldType)
	self.zoomed = false
	self.initialhit = false
	self.Tr = nil

	self.Idle = 0
	self.IdleTimer = CurTime() + 1

	if CLIENT then

		-- Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )
		self:SetWeaponHoldType( self.HoldType )

		self:CreateModels(self.VElements) -- create viewmodels
		self:CreateModels(self.WElements) -- create worldmodels

		-- init view model bone build function
		if IsValid(self:GetOwner()) then
			local vm = self:GetOwner():GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)

				-- Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					-- we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					-- ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					-- however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")
				end
			end
		end

	end

end

----------------------------------------------------
if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()

		local vm = self:GetOwner():GetViewModel()
		if not IsValid(vm) then return end

		if (not self.VElements) then return end

		self:UpdateBonePositions(vm)

		if (not self.vRenderOrder) then

			-- we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end

		end

		for k, name in ipairs( self.vRenderOrder ) do

			local v = self.VElements[name]
			if (not v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end

			local model = v.modelEnt
			local sprite = v.spriteMaterial

			if (not v.bone) then continue end

			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )

			if (not pos) then continue end

			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )

				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial( v.material )
				end

				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end

				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end

				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end

				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)

				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end

			elseif (v.type == "Sprite" and sprite) then

				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)

			elseif (v.type == "Quad" and v.draw_func) then

				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end

		end

	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()

		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end

		if (not self.WElements) then return end

		if (not self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end

		if (IsValid(self:GetOwner())) then
			bone_ent = self:GetOwner()
		else
			-- when the weapon is dropped
			bone_ent = self
		end

		for k, name in pairs( self.wRenderOrder ) do

			local v = self.WElements[name]
			if (not v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end

			local pos, ang

			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end

			if (not pos) then continue end

			local model = v.modelEnt
			local sprite = v.spriteMaterial

			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )

				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial( v.material )
				end

				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end

				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end

				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end

				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)

				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end

			elseif (v.type == "Sprite" and sprite) then

				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)

			elseif (v.type == "Quad" and v.draw_func) then

				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end

		end

	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )

		local bone, pos, ang
		if (tab.rel and tab.rel ~= "") then

			local v = basetab[tab.rel]

			if (not v) then return end


			pos, ang = self:GetBoneOrientation( basetab, v, ent )

			if (not pos) then return end

			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)

		else

			bone = ent:LookupBone(bone_override or tab.bone)

			if (not bone) then return end

			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end

			if (IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() and
				ent == self:GetOwner():GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r -- Fixes mirrored models
			end

		end

		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (not tab) then return end

		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model ~= "" and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) and
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then

				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end

			elseif (v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite)
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then

				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				-- make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)

			end
		end

	end

	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)

		if self.ViewModelBoneMods then

			if (not vm:GetBoneCount()) then return end

			-- !! WORKAROUND !! --
			-- We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (not hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = {
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end

				loopthrough = allbones
			end
			-- !! ----------- !! --

			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (not bone) then continue end

				-- !! WORKAROUND !! --
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (not hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end

				s = s * ms
				-- !! ----------- !! --

				if vm:GetManipulateBoneScale(bone) ~= s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) ~= v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) ~= p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end

	end

	function SWEP:ResetBonePositions(vm)

		if (not vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end

	end


	function table.FullCopy( tab )

		if (not tab) then return nil end

		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v)
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end

		return res

	end

end
----------------------------------------------------

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)


	self.Idle = 0
	self.IdleTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
	return true
end

function SWEP:Think()
	if (not self:GetOwner() || self:GetOwner() == NULL) then return end

	if ( self:GetOwner():KeyPressed( IN_ATTACK ) ) then
		self:StartAttack()
		self.VElements["v_element"].material = "models/weapons/c_items/c_grappling_hook_alphatest"
	elseif ( self:GetOwner():KeyDown( IN_ATTACK ) && inRange ) then
		self:UpdateAttack()
	elseif ( self:GetOwner():KeyReleased( IN_ATTACK ) && inRange ) then
		self:EndAttack( true )
		self.VElements["v_element"].material = "models/weapons/c_items/c_grappling_hook2"
	end

	if self.Idle == 0 and self.IdleTimer <= CurTime() then
		if SERVER then
			self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		end
		self.Idle = 1
	end
end

function SWEP:DoTrace( endpos )
	local trace = {}
	trace.start = self:GetOwner():GetShootPos()
	trace.endpos = trace.start + (self:GetOwner():GetAimVector() * 32768) --14096 is length modifier.
	trace.mins = Vector(-2,-2,-2)
	trace.maxs = Vector(2,2,2)
	if(endpos) then trace.endpos = (endpos - self.Tr.HitNormal * 7) end
	trace.filter = { self:GetOwner(), self.Weapon }

	self.Tr = nil
	self.Tr = util.TraceHull( trace )
end

function SWEP:StartAttack()
	-- Get begining and end poins of trace.
	local gunPos = self:GetOwner():GetShootPos() -- Start of distance trace.
	local disTrace = self:GetOwner():GetEyeTrace() -- Store all results of a trace in disTrace.
	local hitPos = disTrace.HitPos -- Stores Hit Position of disTrace.

	-- Calculate Distance
	-- Thanks to rgovostes for this code.
	local x = (gunPos.x - hitPos.x)^2;
	local y = (gunPos.y - hitPos.y)^2;
	local z = (gunPos.z - hitPos.z)^2;
	local distance = math.sqrt(x + y + z);

	-- Only latches if distance is less than distance CVAR, or CVAR negative
	local distanceCvar = GetConVarNumber("grapple_distance")
	inRange = false
	if distanceCvar < 0 or distance <= distanceCvar then
		inRange = true
	end

	if inRange then
		if (SERVER) then
			if (not self.Beam) then -- If the beam does not exist, draw the beam.
				-- grapple_beam
				self.Beam = ents.Create( "trace2" )
					self.Beam:SetPos( self:GetOwner():GetShootPos() )
				self.Beam:Spawn()
			end
			self.Beam:SetParent( self:GetOwner() )
			self.Beam:SetOwner( self:GetOwner() )
		end

		self:DoTrace()
		self.speed = GetConVarNumber("grapple_latch_speed") -- Rope latch speed. Was 3000.
		self.startTime = CurTime()
		self.endTime = CurTime() + self.speed
		self.dt = -1

		if (SERVER && self.Beam) then
			self.Beam:GetTable():SetEndPos( self.Tr.HitPos )
		end

		self:UpdateAttack()

		if GetConVarNumber("grapple_play_sounds") == 1 then
			self.Weapon:EmitSound( sndGrappleShoot,75 )
		end
	else
		if GetConVarNumber("grapple_play_sounds") == 1 then
			self.Weapon:EmitSound( sndGrappleAbort,70 )
		end
	end
end

function SWEP:UpdateAttack()
	if self.Tr == nil then return false end
	if not endpos then endpos = self.Tr.HitPos end

	if GetConVarNumber("grapple_ignore_sky") == 1 then
		if self.Tr.HitSky then self:EndAttack( false ) return false end
	end

	if (SERVER && self.Beam) then
		self.Beam:GetTable():SetEndPos( endpos )
	end

	lastpos = endpos

	if IsValid(self.Tr.Entity) then
		endpos = self.Tr.Entity:NearestPoint(self.Tr.HitPos)
		if SERVER then
			self.Beam:GetTable():SetEndPos( endpos )
			if GetConVarNumber("grapple_damage_enable") == 1 then
				if self.dt == 0 then
					if timer.TimeLeft( "hurtent" .. self:EntIndex() ) == nil then
						if self.Tr.Entity:IsPlayer() then
							if not self.Tr.Entity:Alive() then
								self:DoTrace()
							end
						end

						if self.Tr.Entity:IsNPC() then
							if self.Tr.Entity:Health() < 0 then
								self:DoTrace()
							end
						end

						local dmgInfo = DamageInfo()
						dmgInfo:SetAttacker(self:GetOwner())
						dmgInfo:SetInflictor(self)
						dmgInfo:SetDamageType(DMG_SLASH)
						dmgInfo:SetDamage(math.random(GetConVarNumber("grapple_damage_min"),GetConVarNumber("grapple_damage_max")))
						dmgInfo:SetDamagePosition(self.Tr.HitPos)
						dmgInfo:SetDamageForce(self:GetOwner():GetAimVector()*-5000)
						self.Tr.Entity:TakeDamageInfo(dmgInfo)
						if GetConVarNumber("grapple_play_sounds") == 1 then
							self.Tr.Entity:EmitSound( "weapons/xbow_hit2.wav",75 ,math.random(95,105) ,1 )
							if self.Tr.Entity:IsPlayer() or self.Tr.Entity:IsNPC() or self.Tr.Entity.Type == "nextbot" then
								self.Tr.Entity:EmitSound( sndGrappleHitFlesh,75 ,math.random(95,105) ,1 )
							end
						end
						if self.Tr.Entity:GetPhysicsObject() then
							local hitphys = self.Tr.Entity:GetPhysicsObject()
							if IsValid(hitphys) then

								if self.initialhit == false then
									hitphys:AddVelocity(self:GetOwner():GetAimVector()*50000/hitphys:GetMass())
								else
									hitphys:AddVelocity(self:GetOwner():GetAimVector()*-50000/hitphys:GetMass())
								end
								self.initialhit = true
							end
						end
						timer.Create( "hurtent" .. self:EntIndex(), 0.5, 1, function() end )
					end
				end
			end
		end
	end

	local vVel = (endpos - self:GetOwner():GetShootPos())
	local Distance = endpos:Distance(self:GetOwner():GetShootPos())
	local et = (self.startTime + (Distance/self.speed))

	if self.dt ~= 0 then
		self.dt = (et - CurTime()) / (et - self.startTime)
		self.VElements["v_element2"].angle = Angle(-1.657, 89.516, -270*CurTime())
		self.VElements["v_element3"].angle = Angle(-1.657, 89.516, 45-270*CurTime())
	end
	if self.dt < 0 then
		if GetConVarNumber("grapple_play_sounds") == 1 then
			self.Weapon:EmitSound( sndGrappleHit )
			sound.Play(sndGrappleHit, self.Tr.HitPos)
		end
		self.dt = 0
	end

	if self.dt == 0 then
		self.VElements["v_element2"].angle = Angle(-1.657, 89.516, 0.8*Distance)
		self.VElements["v_element3"].angle = Angle(-1.657, 89.516, 45+0.8*Distance)
		if GetConVarNumber("grapple_play_sounds") == 1 then
			self.ReelIn = CreateSound(self:GetOwner(), "weapons/grappling_hook_reel_start.wav")
			self.ReelIn:Play()
		end
		zVel = self:GetOwner():GetVelocity().z
		vVel = vVel:GetNormalized()*(math.Clamp(Distance,0,GetConVarNumber("grapple_speed_mk2")))
		if SERVER then
			local gravity = GetConVarNumber("sv_Gravity")
			vVel:Add(Vector(0,0,(gravity/100)*1.5)) -- Player speed. DO NOT MESS WITH THIS VALUE!
			if zVel < 0 then
				vVel:Sub(Vector(0,0,zVel/10))
			end

			self:GetOwner():SetLocalVelocity(vVel)
		end
	end
	endpos = nil
end

function SWEP:EndAttack( shutdownsound )
	if ( shutdownsound ) then
		if GetConVarNumber("grapple_play_sounds") == 1 then
			self.Weapon:EmitSound( sndGrappleAbort,70 )
			if self.ReelIn then
				self.ReelIn:Stop()
			end
		end
	end

	self.initialhit = false

	if ( CLIENT ) then return end
	if ( not self.Beam ) then return end

	self.Beam:Remove()
	self.Beam = nil
end

function SWEP:Holster()
	self:EndAttack( false )
	if CLIENT and IsValid(self:GetOwner()) then
		local vm = self:GetOwner():GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	return true
end

function SWEP:OnRemove()
	self:EndAttack( false )
	return true
end

function SWEP:OnDrop()
	self:Holster()
end

function SWEP:PrimaryAttack()
	self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	self.Idle = 0
	self.IdleTimer = CurTime() + self:GetOwner():GetViewModel():SequenceDuration()
end

function SWEP:SecondaryAttack()
end