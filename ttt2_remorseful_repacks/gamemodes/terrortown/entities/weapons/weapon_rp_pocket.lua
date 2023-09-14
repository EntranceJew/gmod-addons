if SERVER then
	AddCSLuaFile()
	resource.AddFile( "sound/weapons/g2contender/bullet_in.mp3" )
	resource.AddFile( "sound/weapons/g2contender/bullet_out.mp3" )
	resource.AddFile( "sound/weapons/g2contender/close_chamber.mp3" )
	resource.AddFile( "sound/weapons/g2contender/cock-1.mp3" )
	resource.AddFile( "sound/weapons/g2contender/cock-2.mp3" )
	resource.AddFile( "sound/weapons/g2contender/draw.mp3" )
	resource.AddFile( "sound/weapons/g2contender/open_chamber.mp3" )
	resource.AddFile( "sound/weapons/g2contender/pl_shell1.mp3" )
	resource.AddFile( "sound/weapons/g2contender/pl_shell2.mp3" )
	resource.AddFile( "sound/weapons/g2contender/pl_shell3.mp3" )
	resource.AddFile( "sound/weapons/g2contender/pl_shell4.mp3" )
	resource.AddFile( "sound/weapons/g2contender/scout-2.wav" )
	resource.AddFile( "models/weapons/v_contender2.mdl" )
	resource.AddFile( "models/weapons/w_g2_contender.mdl" )
	resource.AddFile( "materials/vgui/ttt/lykrast/icon_rp_pocket.vmt" )
	resource.AddFile( "materials/vgui/ttt/lykrast/icon_rp_pocket.vtf" )
	resource.AddFile( "materials/models/weapons/w_models/g2contender/diffuse.vmt" )
	resource.AddFile( "materials/models/weapons/w_models/g2contender/uv1024.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/g2contender/bullet.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/g2contender/bullet.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/g2contender/contender_diffuse.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/g2contender/contender_normal.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/g2contender/diffuse.vmt" )
	resource.AddFile( "materials/models/weapons/v_models/g2contender/scope_diffuse.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/g2contender/scope_normal.vtf" )
	resource.AddFile( "materials/models/weapons/v_models/g2contender/uv1024.vmt" )
end

SWEP.HoldType			= "revolver"

if CLIENT then
   SWEP.PrintName			= "Pocket Rifle"			
   SWEP.Author				= "TTT"

   SWEP.Slot				= 1
   SWEP.SlotPos			= 1

   SWEP.Icon = "vgui/ttt/lykrast/icon_rp_pocket"
end

SWEP.Base				= "weapon_tttbase"

SWEP.Spawnable = true
SWEP.Kind = WEAPON_PISTOL

SWEP.Primary.Ammo       = "357"
SWEP.Primary.Recoil	= 8
SWEP.Primary.Damage = 43
SWEP.Primary.Delay = 1.7
SWEP.Primary.Cone = 0.005
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 20
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true

SWEP.HeadshotMultiplier = 4

SWEP.AutoSpawnable      = true
SWEP.AmmoEnt = "item_ammo_357_ttt"
SWEP.Primary.Sound = "weapons/g2contender/scout-2.wav"

SWEP.Secondary.Sound = Sound("Default.Zoom")

SWEP.UseHands			= false
SWEP.ViewModelFlip		= false
SWEP.ViewModelFOV		= 70
SWEP.ViewModel			= "models/weapons/v_contender2.mdl"
SWEP.WorldModel			= "models/weapons/w_g2_contender.mdl"

SWEP.IronSightsPos = Vector(-3, -15.857, 0.36)
SWEP.IronSightsAng = Vector(0, 0, 0)

function SWEP:PrimaryAttack(worldsnd)

   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

   self:TakePrimaryAmmo( 1 )

   local owner = self.Owner
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )

   self:Reload()
end

function SWEP:SetZoom(state)
    if CLIENT then
       return
    elseif IsValid(self.Owner) and self.Owner:IsPlayer() then
       if state then
          self.Owner:SetFOV(20, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self:GetNextSecondaryFire() > CurTime() then return end

    local bIronsights = not self:GetIronsights()

    self:SetIronsights( bIronsights )

    if SERVER then
        self:SetZoom(bIronsights)
     else
        self:EmitSound(self.Secondary.Sound)
    end

    self:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
    self:SetZoom(false)
    self:SetIronsights(false)
    return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
    self:DefaultReload( ACT_VM_RELOAD )
    self:SetIronsights( false )
    self:SetZoom( false )
end


function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)
    return true
end

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local x = ScrW() / 2.0
         local y = ScrH() / 2.0
         local scope_size = ScrH()

         -- crosshair
         local gap = 80
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         gap = 0
         length = 50
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )


         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)

         surface.SetDrawColor(255, 0, 0, 255)
         surface.DrawLine(x, y, x + 1, y + 1)

         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)

      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end