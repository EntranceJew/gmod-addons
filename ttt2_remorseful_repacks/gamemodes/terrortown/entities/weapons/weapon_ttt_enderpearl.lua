AddCSLuaFile()

resource.AddFile( "sound/weapons/weapon_ttt_enderpearl/bow.mp3" )
resource.AddFile( "sound/weapons/weapon_ttt_enderpearl/teleport.mp3" )
resource.AddFile( "materials/models/weapons/weapon_ttt_enderpearl/endpearl.png" )
resource.AddFile( "materials/entities/weapon_ttt_enderpearl.png" )
resource.AddFile( "materials/vgui/ttt/icon_ttt_enderpearl.png" )

SWEP.PrintName = "Enderpearl"
SWEP.Author = "VvonB, Cowskier"
SWEP.Instructions = "Flex on those Endermen with your own authentic enderpearls!"
SWEP.Spawnable = true
SWEP.Icon = "vgui/ttt/icon_ttt_enderpearl.png"
SWEP.EquipMenuData = {
	type = "item_weapon",
	name = "Ender Pearl",
	desc = "Flex on those Endermen with your own authentic enderpearls!"
}

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_SPECIAL
SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.AutoSpawnable = false
SWEP.InLoadoutFor = nil

SWEP.ViewModel = Model( "models/weapons/c_bugbait.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_bugbait.mdl" )
SWEP.ViewModelFOV = 15
SWEP.UseHands = false

local SwingSound = Sound( "weapons/ttt2_ender_pearl/teleport.mp3" )

SWEP.Primary.ClipSize = 16
SWEP.Primary.DefaultClip = 16
SWEP.Secondary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
function SWEP:Initialize()

	self:SetHoldType( "grenade" )
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return self:Clip1() > 0
end

function SWEP:SecondaryAttack()
	if (self:Clip1() <= 0) then
		self:Remove()
		return
	end
	self:SetClip1(self:Clip1() - 1)
	self:SetNextPrimaryFire( CurTime() + .5 )
	sound.Play("weapons/weapon_ttt_enderpearl/bow.mp3",self:GetOwner():GetPos())
	self:EmitSound( SwingSound )
	self:ShootEffects( self )

	if ( not SERVER ) then return end

	local Forward = self:GetOwner():EyeAngles():Forward()
	local ent = ents.Create( "sent_enderpearl" )

	if ( IsValid( ent ) ) then
		ent:SetPos( self:GetOwner():GetShootPos() + Forward * 32 )
		ent:SetAngles( self:GetOwner():EyeAngles() )
		ent:Spawn()
		ent:SetNWString("id",self:GetOwner():SteamID())
	  	ent:GetPhysicsObject():SetVelocity( Forward * 1000 )
	end
	if (self:Clip1() <= 0) then
		self:Remove()
	end

end

function SWEP:ViewModelDrawn()
	local own = self:GetOwner()
	local eye = own:EyeAngles()
	local pearl = Material("models/weapons/weapon_ttt_enderpearl/endpearl.png", "smooth mips")
	local position = own:GetViewModel():GetPos()
		+ eye:Forward() * 40
		+ eye:Right() * 3.5
		+ eye:Up() * -2
	render.SetMaterial( pearl )
	render.DrawSprite(position, 4, 4)
end

function SWEP:DrawWorldModel()
	--self:DrawModel()
end
