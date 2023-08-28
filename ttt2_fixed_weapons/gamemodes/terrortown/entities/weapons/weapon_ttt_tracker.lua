-- Tracker

if SERVER then
   AddCSLuaFile()
end

DEFINE_BASECLASS "weapon_tttbase"

if CLIENT then
   SWEP.PrintName = "Tracker"
   SWEP.Author = "CountLow"
   SWEP.Slot      = 6

   SWEP.ViewModelFOV  = 54
   SWEP.ViewModelFlip = false
end

SWEP.Base				= "weapon_tttbase"

SWEP.HoldType			= "ar2"
SWEP.UseHands = true

SWEP.Primary.Delay       = 1.5
SWEP.Primary.Recoil      = 4
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo        = ""
SWEP.Primary.ClipSize    = 2
SWEP.Primary.ClipMax     = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Sound       = Sound( "Weapon_AWP.Silenced" )

SWEP.IronSightsPos = Vector( 6.05, -5, 2.4 )
SWEP.IronSightsAng = Vector( 2.2, -0.1, 0 )

SWEP.ViewModel  = "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"

SWEP.Kind = WEAPON_EQUIP1

SWEP.AutoSpawnable = false

SWEP.AmmoEnt = ""

SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }

SWEP.InLoadoutFor = nil

SWEP.LimitedStock = true

SWEP.AllowDrop = true

SWEP.IsSilent = false

SWEP.NoSights = false

if CLIENT then
   SWEP.Icon = "VGUI/ttt/icon_dart"

   SWEP.EquipMenuData = {
      type = "Weapon",
      desc = "Every target hit by your tracking darts\nwill be visible everytime"
   };
end

if SERVER then
   resource.AddFile("materials/VGUI/ttt/icon_dart.vmt")
end



local tracked = {}
local prog = 0

function SWEP:PrimaryAttack()
 if ( !self:CanPrimaryAttack() ) then return end
    if SERVER then

        self:SetNextPrimaryFire(CurTime() + 1.5)

        self:EmitSound( "Weapon_AWP.Silenced" )

        self:ShootBullet( 0, 1, 0.001 )

        self:TakePrimaryAmmo( 1 )

        self:GetOwner():ViewPunch( Angle( -4, 0, 0 ) )
    end
    if CLIENT then

        local ply = self:GetOwner()
        local tr = ply:GetEyeTrace()
        local tar = tr.Entity

        if (tar.IsPlayer() == false) then return end

        tracked[prog] = tar

        prog = prog + 1
    end
end


hook.Add("PreDrawHalos", "Draw", function()
    for a = 0, #tracked, 1 do
        if (IsValid(tracked[a]) and tracked[a]:Alive() == false) then tracked[a] = false end
    end
    halo.Add(tracked, Color(255,165,0, 255), 2, 2, 10, false, true)
end)

hook.Add("TTTBeginRound", "start", function()
    if CLIENT then
        prog = 0
        table.Empty( tracked )
    end
end)

hook.Add("TTTPrepareRound", "prep", function()
    if CLIENT then
        prog = 0
        table.Empty( tracked )
    end
end)



local swap = false

function SWEP:SecondaryAttack()
    local use = self:GetOwner()

    swap =  !swap

    if (swap) then
        use:SetFOV(10, 0.1)
        self:SetIronsights( true )
        self:SetNextSecondaryFire(CurTime() + 0.3)
    else
        use:SetFOV(0, 0.1)
        self:SetIronsights( false )
        self:SetNextSecondaryFire(CurTime() + 0.3)
    end

end

function reset(weap, own)
    swap = !swap
    if IsValid(own) and own.SetFOV then
        own:SetFOV(0, 0.1)
    end
    if IsValid(weap) and weap.SetIronsights then
        weap:SetIronsights( false )
    end
end

function SWEP:Holster()
    reset(self, self:GetOwner())
    return true
end

function SWEP:Reload()
    reset(self, self:GetOwner())
end

hook.Add("PlayerDroppedWeapon", "Drop", function(dropr, weap)
    reset(weap, dropr)
end)



function SWEP:AdjustMouseSensitivity()
    return (self:GetIronsights() and 0.2) or nil
end

if CLIENT then
    SWEP.iron_sight_material = Material("vgui/nb/nbscope.png")
end

function SWEP:DrawHUD()
     if CLIENT and IsValid(self) and self.GetIronsights and self:GetIronsights() then
        local resX = ScrW() --1080 -> 1920
        local resY = ScrH() --1080 -> 1080

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial(self.iron_sight_material)
        surface.DrawTexturedRect(resX / 4.571, 0 , resX / 1.777, resY)
    end
end
