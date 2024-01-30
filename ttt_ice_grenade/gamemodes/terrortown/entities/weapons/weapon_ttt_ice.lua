AddCSLuaFile()

if ( SERVER ) then
	resource.AddFile("materials/vgui/ttt/icon_64_icegrenade.png")
	resource.AddFile("models/weapons/ice_grenade/icegrenade.dx80.vtx")
	resource.AddFile("models/weapons/ice_grenade/icegrenade.dx90.vtx")
	resource.AddFile("models/weapons/ice_grenade/icegrenade.mdl")
	resource.AddFile("models/weapons/ice_grenade/icegrenade.phy")
	resource.AddFile("models/weapons/ice_grenade/icegrenade.sw.vtx")
	resource.AddFile("models/weapons/ice_grenade/icegrenade.vvd")
	resource.AddFile("materials/models/icegrenade/grenadeice.vmt")
	resource.AddFile("materials/models/icegrenade/grenadeice.vtf")
	resource.AddFile("models/weapons/ice_grenade/icegrenadew.dx80.vtx")
	resource.AddFile("models/weapons/ice_grenade/icegrenadew.dx90.vtx")
	resource.AddFile("models/weapons/ice_grenade/icegrenadew.mdl")
	resource.AddFile("models/weapons/ice_grenade/icegrenadew.phy")
	resource.AddFile("models/weapons/ice_grenade/icegrenadew.sw.vtx")
	resource.AddFile("models/weapons/ice_grenade/icegrenadew.vvd")
	resource.AddFile("materials/models/icegrenade/grenadeicew.vmt")
	resource.AddFile("materials/models/icegrenade/grenadeicew.vtf")
	resource.AddFile("sound/weapons/ice_grenade/ice_crack.wav")
	resource.AddFile("sound/weapons/ice_grenade/ice_explosion.wav")
	resource.AddFile("particles/iceexplode.pcf")
end

game.AddParticles( "particles/iceexplode.pcf" )
PrecacheParticleSystem( "ice_explosion" )

if CLIENT then
   SWEP.PrintName = "Ice Grenade"
   SWEP.Author = "Thahunter"
   SWEP.Slot = 6
   -- SWEP.DrawAmmo = false
   -- SWEP.DrawCrosshair = false
   -- SWEP.Contact = "Thahunter - Steam ID: Thahunter_Steam"
   -- SWEP.Purpose = "Freeze Enemies!"
   -- SWEP.Instructions = "Left click to throw"
   SWEP.EquipMenuData = {
      type = "Weapon",
      name = "Ice Grenade",
      desc = "A grenade that emits a cold snap.",
   }
   SWEP.Icon = "vgui/ttt/icon_64_icegrenade.png"
end

--Convars
local differentroles = { }
local deterole = CreateConVar("ttt_icegrenade_detective", "1")
local traitorrole = CreateConVar("ttt_icegrenade_traitor", "0")

if traitorrole:GetBool() && deterole:GetBool() then
  differentroles = {ROLE_TRAITOR, ROLE_DETECTIVE}
elseif traitorrole:GetBool() then
  differentroles = {ROLE_TRAITOR}
elseif deterole:GetBool() then
  differentroles = {ROLE_DETECTIVE}
end

-- Always derive from weapon_tttbasegrenade
SWEP.Base = "weapon_tttbasegrenade"

-- Standard GMod values
SWEP.HoldType = "grenade"
SWEP.Weight = 5

-- Model settings
SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 56
SWEP.ViewModel = "models/weapons/ice_grenade/icegrenade.mdl"
SWEP.WorldModel	 = "models/weapons/ice_grenade/icegrenadew.mdl"
SWEP.IsGrenade = true

--- TTT config values

-- Kind specifies the category this weapon is in. Players can only carry one of
-- each. Can be: WEAPON_... MELEE, PISTOL, HEAVY, NADE, CARRY, EQUIP1, EQUIP2 or ROLE.
-- Matching SWEP.Slot values: 0      1       2     3      4      6       7        8
SWEP.Kind = WEAPON_NADE

-- If AutoSpawnable is true and SWEP.Kind is not WEAPON_EQUIP1/2, then this gun can
-- be spawned as a random weapon.
SWEP.AutoSpawnable = false
SWEP.AdminSpawnable = true

-- CanBuy is a table of ROLE_* entries like ROLE_TRAITOR and ROLE_DETECTIVE. If
-- a role is in this table, those players can buy this.
SWEP.CanBuy = differentroles

-- InLoadoutFor is a table of ROLE_* entries that specifies which roles should
-- receive this weapon as soon as the round starts. In this case, none.
SWEP.InLoadoutFor = { nil }

-- If LimitedStock is true, you can only buy one per round.
SWEP.LimitedStock = false

-- If AllowDrop is false, players can't manually drop the gun with Q
SWEP.AllowDrop = true

-- If NoSights is true, the weapon won't have ironsights
SWEP.NoSights = true

function SWEP:GetGrenadeName()
   return "ttt_ice_proj"
end

-- Equipment menu information is only needed on the client
if CLIENT then
   -- Text shown in the equip menu
   SWEP.EquipMenuData = {
      type = "Ice Grenade",
      desc = "A grenade that emits a cold snap."
   }
end
