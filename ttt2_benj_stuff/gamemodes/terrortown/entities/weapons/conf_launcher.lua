
AddCSLuaFile()
DEFINE_BASECLASS "weapon_tttbase"
SWEP.HoldType           = "rpg"



if CLIENT then
   SWEP.PrintName       = "conflaunch_name"
   SWEP.Slot            = 7

   SWEP.ViewModelFlip   = false
   SWEP.ViewModelFOV    = 54

   SWEP.Icon            = "vgui/ttt/icon_nades"
   SWEP.IconLetter      = "h"
end

SWEP.Base               = "weapon_tttbasegrenade"

SWEP.Primary.Recoil        = 1.35
SWEP.Primary.Damage        = 28
SWEP.Primary.Delay         = 0.38
SWEP.Primary.Cone          = 0.02
SWEP.Primary.ClipSize      = 20
SWEP.Primary.Automatic     = true
SWEP.Primary.DefaultClip   = 20
SWEP.Primary.ClipMax       = 60
SWEP.Primary.Ammo          = "weapon_ttt_confgrenade"
SWEP.Primary.Sound         = Sound( "Weapon_Pistol.Empty" )
SWEP.Primary.SoundLevel    = 50

SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_TRAITOR} -- only traitors can buy
SWEP.WeaponID              = AMMO_SIPISTOL

function SWEP:StartThrow()
   self:SetThrowTime(CurTime() + 0.1)
end

function SWEP:BlowInFace() 

end

function SWEP:PreDrop() 

end

function SWEP:Think()
   BaseClass.Think(self)
   local ply = self:GetOwner()
   if not IsValid(ply) then return end

   -- pin pulled and attack loose = throw
   if self:GetPin() then
      -- we will throw now
      if not ply:KeyDown(IN_ATTACK) then
         self:StartThrow()

         self:SetPin(false)
         self:SendWeaponAnim(ACT_VM_THROW)

         if SERVER then
            self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
         end
      end
   elseif self:GetThrowTime() > 0 and self:GetThrowTime() < CurTime() then
      self:Throw()
   end
end

function SWEP:Throw()
   if CLIENT then
      self:SetThrowTime(1)
   elseif SERVER then
      local ply = self:GetOwner()
      if not IsValid(ply) then return end

      local ang = ply:EyeAngles()
      local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset())+ (ang:Forward() * 8) + (ang:Right() * 10)
      local target = ply:GetEyeTraceNoCursor().HitPos
      local tang = (target-src):Angle() -- A target angle to actually throw the grenade to the crosshair instead of fowards
      -- Makes the grenade go upgwards
      if tang.p < 90 then
         tang.p = -10 + tang.p * ((90 + 10) / 90)
      else
         tang.p = 360 - tang.p
         tang.p = -10 + tang.p * -((90 + 10) / 90)
      end
      tang.p=math.Clamp(tang.p,-90,90) -- Makes the grenade not go backwards :/
      local vel = math.min(2000)
      local thr = tang:Forward() * vel + ply:GetVelocity()
      gren = self:CreateGrenade(src, Angle(0,0,0), thr, Vector(600, math.random(-1200, 1200), 0), ply)
	
		function ENT:PhysicsCollide( data, phys )
			if phys == gren:GetPhysicsObject() then
				gren:Explode()
			end
		end
	
	
      self:SetThrowTime(0)
   end
end


SWEP.WeaponID           = AMMO_DISCOMB
SWEP.Kind               = WEAPON_NADE

SWEP.Spawnable          = false
SWEP.AutoSpawnable      = false

SWEP.UseHands           = true
SWEP.ViewModel          = "models/weapons/c_rpg.mdl"
SWEP.WorldModel         = "models/weapons/w_rocket_launcher.mdl"

SWEP.Weight             = 5

-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "ttt_confgrenade_proj"
end

