local flags = {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}
CreateConVar("ttt_prop_disguiser_time", 10, flags)
CreateConVar("ttt_prop_disguiser_cooldown", 30, flags)
CreateConVar("ttt_prop_disguiser_min_prop_size", 5, flags)
CreateConVar("ttt_prop_disguiser_max_prop_size", 100, flags)

if SERVER then
	AddCSLuaFile()
	util.AddNetworkString( "DisguiseDestroyed" )
	util.AddNetworkString( "PD_ChatPrint" )
end

if CLIENT and TTT2 and STATUS then
	hook.Add("Initialize", "prop_disguiser_Initialize", function()
		STATUS:RegisterStatus("prop_disguiser_disguised", {
			hud = Material("vgui/ttt/hud_icon_deadringer.png"),
			type = "default"
		})

		STATUS:RegisterStatus("prop_disguiser_cooldown", {
			hud = Material("vgui/ttt/hud_icon_deadringer.png"),
			type = "bad"
		})
		return
	end)
end


--[[
	based on Jonascone's SWEP,
	redone by Exho,
	fixed by Perwex, AlgeeTwice, EntranceJew

	see TTT2: https://steamcommunity.com/sharedfiles/filedetails/?id=1357204556&searchtext=ttt2
	V: 01/17/24
]]

if CLIENT then
	SWEP.PrintName = "Prop Disguiser"
	SWEP.Slot = 7
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true

	SWEP.Icon = "vgui/ttt/ttt_prop_disguiser.png"

	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "Allows you to disguise yourself as a Prop!\n\nReload key to select a new prop."
	}
end

SWEP.HoldType = "normal"
SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AutoSpawnable = false
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
------ CONFIGURATION ------
SWEP.Secondary.Delay = 2 -- The exact opposite of the Time limit after un-disguising until next disguise
SWEP.DisguiseProp = Model("models/props_c17/oildrum001.mdl") -- Default disguise model


SWEP.Prop = nil
SWEP.Disguised = false
SWEP.AllowDrop = true

-- Put the Model Names of props that pass the criteria but you don't want anyone to use. Separate each string WITH a comma
-- Example of a model path would be "models/props_junk/wood_crate001a.mdl"
SWEP.Blacklist = {

}

if CLIENT then
	function SWEP:Initialize()
		self:RefreshTTT2HUDHelp()

		return self.BaseClass.Initialize(self)
	end

	function SWEP:RefreshTTT2HUDHelp()
		if self:GetNWBool("PD_WepDisguised") then
			self:AddTTT2HUDHelp("prop_disguiser_help_sec")
		else
			self:AddTTT2HUDHelp("prop_disguiser_help_pri", "prop_disguiser_help_reload")
		end
	end

end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()

	if not self:GetNWBool("PD_WepDisguised") then
		if IsValid(self.Prop) then self.Prop:Remove() end -- Just in case the prop already exists
		ply:SetNWBool("PD_Disguised", true)
		self:PropDisguise() -- The main attraction, disguise
	else
		print("hmm")
		self:GetOwner():SetNWBool("PD_Disguised", false)
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
		self:PropUnDisguise()
	end
end

function SWEP:SecondaryAttack()
	print("what")
	if self:GetNWBool("PD_WepDisguised") then -- If you are a prop, the trace 'hits' your entity.
		if SERVER then
			LANG.Msg(self:GetOwner(), "prop_disguiser_error_model_pick_while_disguised", nil, MSG_MSTACK_WARN)
		end
		return
	else
		self:ModelHandler()
	end
end

function SWEP:PropDisguise()
	local ply = self:GetOwner()
	local time = GetConVar("ttt_prop_disguiser_time"):GetInt()

	if SERVER and self:GetNWBool("PD_WepDisguised") then
		LANG.Msg(ply, "prop_disguiser_error_already_disguised", nil, MSG_MSTACK_WARN)
		return
	end

	--self.Disguised = true
	self:SetNWBool("PD_TimeOut", false)
	if not IsValid(ply) or not ply:Alive() then print("Player ain't valid, yo") return end

	timer.Create(ply:SteamID64() .. "_DisguiseTime", time, 1, function()
		self:SetNWBool("PD_TimeOut", true)
		--self:SetNextPrimaryFire(CurTime()+self.Primary.Delay + 5) -- Small delay after timer going out
		self:PropUnDisguise()
	end)
	if SERVER then
		-- Undisguise after the time limit
		ply:SetNWFloat("PD_TimeLeft", CurTime() + time) -- Client-side timer
		ply:SetNWBool("PD_Disguised", true) -- Shared - player disguised
		self:SetNWBool("PD_WepDisguised", true)

		ply:SelectWeapon(self:GetClass())
		local prop = ents.Create("prop_physics") -- Create our disguise
		self.Prop = prop
		prop:SetModel(self.DisguiseProp)
		local ang = ply:GetAngles()
		ang.x = 0 -- The Angles should always be horizontal
		prop:SetAngles(ang)
		prop:SetPos(ply:GetPos() + Vector(0,0, 20))
		prop.fakeHp = ply:Health() / 2 -- Using our own health value
		prop.hp_constant = ply:Health() / 2
		ply:SetHealth(ply:Health() / 2) -- This is the prop's health but displayed as their own
		prop.IsADisguise = true -- Identifier for our prop
		prop.TiedPly = ply -- The Master
		prop:SetName(ply:Nick() .. "'s Disguised Prop") -- Prevent spectator possessing if TTT
		ply.DisguisedProp = prop

		prop:Spawn()

		local phys = prop:GetPhysicsObject()
		if not IsValid(phys) then return end
		phys:SetVelocity(ply:GetVelocity())

		-- Spectate it
		ply:Spectate(OBS_MODE_CHASE)
		ply:SpectateEntity(self.Prop)
		ply:SelectWeapon(self:GetClass())
		self.AllowDrop = false
		ply:DrawViewModel(false)
		ply:DrawWorldModel(false)

		-- STATUS
		STATUS:AddTimedStatus(ply, "prop_disguiser_disguised", time, true)
	end
	if CLIENT then
		self:RefreshTTT2HUDHelp()
	end
end

function SWEP:PropUnDisguise()
	local ply = self:GetOwner()
	local prop = self.Prop
	local cd = GetConVar("ttt_prop_disguiser_cooldown"):GetInt()

	if IsValid(ply) and IsValid(self.Prop) and self:GetNWBool("PD_WepDisguised") then
		-- TODO: Utilize state storage here!
		local creditsSave = ply:GetCredits()
		local equipNumSave = ply:GetEquipmentItems()
		local tempHp = ply:Health() * 2

		prop.IsADisguise = false
		ply:SetNWFloat("PD_TimeLeft", 0)
		ply:SetNWBool("PD_Disguised", false)
		self:SetNWBool("PD_WepDisguised", false)

		if CLIENT then
			self:RefreshTTT2HUDHelp()
		end

		timer.Remove(ply:SteamID64() .. "_DisguiseTime")

		ply:UnSpectate()
		ply:Spawn() -- We have to spawn before editing anything
		self.AllowDrop = true

		ply:SetAngles(prop:GetAngles())
		ply:SetPos(prop:GetPos())
		ply:SetHealth(tempHp) -- Clamp health, explanation below
		ply:SetVelocity(prop:GetVelocity())
		ply:DrawViewModel(true)
		ply:DrawWorldModel(true)
		ply:SelectWeapon(self:GetClass())
		prop:Remove() -- Banish our prop
		prop = nil

		self:SetNextPrimaryFire(CurTime() + cd)
		ply:SetCredits(creditsSave)
		ply:GiveEquipmentItem(equipNumSave)

		if SERVER then
			STATUS:AddTimedStatus(ply, "prop_disguiser_cooldown", cd, true)
			STATUS:RemoveStatus(ply, "prop_disguiser_disguised")
		end
	end
end

local seen
function SWEP:ModelHandler()
	local ply = self:GetOwner() -- Ply is a lot easier to type
	local tr = ply:GetEyeTrace()
	local ent = tr.Entity

	if seen then return end -- To prevent chat spamming of messages
	seen = true
	timer.Simple(1, function() seen = false end)

	if ent:IsPlayer() or ent:IsNPC() or ent:GetClass() == "prop_ragdoll" or tr.HitWorld or ent:IsWeapon() then
		if SERVER then
			LANG.Msg(ply, "prop_disguiser_error_not_a_prop", nil, MSG_MSTACK_WARN)
		end
		return
	elseif IsValid(ent) then -- The PROP is valid
		if string.sub( ent:GetClass(), 1, 5 ) ~= "prop_" then -- The last check
			if SERVER then
				LANG.Msg(ply, "prop_disguiser_error_not_a_valid_prop", nil, MSG_MSTACK_WARN)
			end
			return
		end
		-- This entity IS a prop without a shadow of a doubt.
		for CANT, EVEN in pairs(self.Blacklist) do
			if ent:GetModel() == EVEN then
				if SERVER then
					LANG.Msg(ply, "prop_disguiser_error_blacklisted_prop", nil, MSG_MSTACK_WARN)
				end
				return
			end
		end

		local mdl = ent:GetModel()
		local rad = ent:BoundingRadius()
		if rad < GetConVar("ttt_prop_disguiser_min_prop_size"):GetInt() then -- All self explanatory
			if SERVER then
				LANG.Msg(ply, "prop_disguiser_error_too_small", nil, MSG_MSTACK_WARN)
			end
			return
		elseif rad > GetConVar("ttt_prop_disguiser_max_prop_size"):GetInt() then
			if SERVER then
				LANG.Msg(ply, "prop_disguiser_error_too_large", nil, MSG_MSTACK_WARN)
			end
			return
		else -- If its not a bad prop, choose it.
			self.DisguiseProp = mdl
			if SERVER then
				LANG.Msg(ply, "prop_disguiser_alert_model_changed", {mdl = mdl}, MSG_MSTACK_WARN)
			end
		end
	end
end

--[[
function SWEP:DrawHUD()
	local ply = self:GetOwner()
	local propped = ply:GetNWBool("PD_Disguised")
	local disguised = self:GetNWBool("PD_WepDisguised")
	local time = GetGlobalInt("ttt_prop_disguiser_time", 10)

	if disguised and propped then
		-- local w = ScrW()
		-- local h = ScrH()
		local x_axis, y_axis, width, height = 800, 98, 320, 54
		draw.RoundedBox(2, x_axis, y_axis, width, height, Color(10,10,10,200))

		local timeLeft = ply:GetNWFloat("PD_TimeLeft") - CurTime() -- Subtract (float + Cur) from Cur
		timeLeft = math.Round(timeLeft or 0, 1) -- Round for simplicity
		timeLeft = math.Clamp(timeLeft, 0, time) -- Clamp to prevent negatives

		local Segments = width / time -- Divide the width into the timer
		local CountdownBar = timeLeft * Segments -- Bar length
		CountdownBar = math.Clamp(CountdownBar, 3, 320)

		draw.RoundedBox(2, x_axis, y_axis, CountdownBar, height, Color(52, 152, 219,200))
		draw.SimpleText(timeLeft, "Trebuchet24", x_axis + 160, y_axis + 27, Color(255,255,255,255), 1, 1)
	end
end
]]

local function DeathHandler(ply, inflictor, att)
	if ply:GetNWBool("PD_Disguised") and IsValid(ply.DisguisedProp) then
		timer.Remove(ply:SteamID64() .. "_DisguiseTime")
		ply.DisguisedProp:Remove() -- If the player is disguised, remove their disguise.
	end
end

local function DamageHandler( ent, dmginfo ) -- Entity Take Damage
	-- Damage method copied from my Destructible Doors and Door Locker addons
	if ent.IsADisguise and SERVER and IsValid(ent.TiedPly) then
		local ply = ent.TiedPly

		local mdl = ent:GetModel()
		local h = ent.fakeHp
		local dmg = dmginfo:GetDamage()
		ent.fakeHp = h - dmg -- Artificially take damage for the prop
		ent.hp_constant = ent:Health() -- Make sure this stays updated
		if ent.fakeHp <= 0 then
			net.Start("DisguiseDestroyed")
			net.Send(ply) -- Tell the client to draw our fancy messages

			ply:Kill() -- Kill the player

			-- EFFECTS!
			local ed = EffectData()
			ed:SetOrigin( ent:GetPos() + ent:OBBCenter() )
			ed:SetMagnitude( 5 )
			ed:SetScale( 2 )
			ed:SetRadius( 5 )
			util.Effect( "Sparks", ed )
			ent:Remove() -- Remove the disguise
		else
			-- Sometimes the Prop's defined Health is lower than what it should be, so it gets destroyed early.
			-- This is a fix for it
			timer.Simple(0.5, function() -- Wait a little bit
				if not IsValid(ent) and ply:GetNWBool("PD_Disguised") then
					-- Player is disguised but the disguise doesn't exist anymore
					print("[Prop Disguise Debug]")
					print(ply:Nick() .. " used wonky prop (" .. mdl .. ") and was automatically killed!")
					print("Recommended you add this prop to the blacklist")
					ply:Kill() -- Kill the player
					net.Start("DisguiseDestroyed")
					net.Send(ply)
				end
			end)
		end
	end
end


local function RoundEndHandler()
	for i, v in ipairs( player.GetAll() ) do
			if v:GetNWBool("PD_Disguised") then
			timer.Remove(v:SteamID64() .. "_DisguiseTime")
			if IsValid(v.DisguisedProp) then
				v.DisguisedProp:Remove() -- If the player is disguised, remove their disguise.
			end
		end
	end
end

hook.Add("EntityTakeDamage","PropDisguise_CauseGodModeIsOP", DamageHandler)
hook.Add("PlayerDeath","PropDisguise_EntDestroyerOnDeath", DeathHandler)
hook.Add("TTTEndRound","PropDisguise_EntDestroyerOnRoundEnd", RoundEndHandler)
hook.Add("TTTPrepareRound","PropDisguise_EntDestroyerOnRoundPrep", RoundEndHandler)

if CLIENT then
	local white = Color( 255, 255, 255 )
	local PropDisguiseCol = Color(52, 152, 219)

	net.Receive( "DisguiseDestroyed", function( len, ply ) -- Receive the message
		chat.AddText( PropDisguiseCol, "Prop Disguiser: ", white,
		"Your disguise was destroyed and you were ",  Color( 170, 0, 0 ), "KILLED",white,"!!")
	end)

	net.Receive( "PD_ChatPrint", function( len, ply ) -- Receive the message
		local txt = net.ReadString()
		chat.AddText( PropDisguiseCol, "Prop Disguiser: ", white, txt)
	end)
end


if CLIENT and TTT2 then
	function SWEP:AddToSettingsMenu(parent)
		local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")

		form:MakeHelp({
			label = "help_ttt_prop_disguiser_time",
		})
		form:MakeSlider({
			label = "label_ttt_prop_disguiser_time",
			serverConvar = "ttt_prop_disguiser_time",
			min = 1,
			max = 100,
			decimal = 0,
		})

		form:MakeHelp({
			label = "help_ttt_prop_disguiser_cooldown",
		})
		form:MakeSlider({
			label = "label_ttt_prop_disguiser_cooldown",
			serverConvar = "ttt_prop_disguiser_cooldown",
			min = 1,
			max = 100,
			decimal = 0,
		})

		form:MakeHelp({
			label = "help_ttt_prop_disguiser_min_prop_size",
		})
		form:MakeSlider({
			label = "label_ttt_prop_disguiser_min_prop_size",
			serverConvar = "ttt_prop_disguiser_min_prop_size",
			min = 1,
			max = 200,
			decimal = 0,
		})

		form:MakeHelp({
			label = "help_ttt_prop_disguiser_max_prop_size",
		})
		form:MakeSlider({
			label = "label_ttt_prop_disguiser_max_prop_size",
			serverConvar = "ttt_prop_disguiser_max_prop_size",
			min = 1,
			max = 200,
			decimal = 0,
		})
	end
end