AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
resource.AddFile( "sound/weapons/weapon_ttt_enderpearl/teleport.mp3" )

function ENT:Initialize()
	self:SetModel("models/Gibs/HGIBS.mdl")
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end
function ENT:Think()
	self.NextEffect = CurTime() + .5
	local ent = ents.Create( "sent_enderparticle" )
	if IsValid( ent ) then
		ent:SetPos( self:GetPos() )
		ent:Spawn()
	end
end
function ENT:PhysicsCollide( data, phys )
	if (data.TheirSurfaceProps == util.GetSurfaceIndex("default_silent")) then
		return
	end

	-- prevent double teleportation which would result in additional fall damage to the player
	if self:GetNWBool("tp", false) then return end
	self:SetNWBool("tp", true)

	local ply = player.GetBySteamID( self:GetNWString("id") )

	local damageInfo = DamageInfo()
	damageInfo:SetDamage(5)
	damageInfo:SetDamageType(DMG_FALL)
	damageInfo:SetInflictor(ply)
	damageInfo:SetAttacker(ply)
	ply:TakeDamageInfo(damageInfo)

	sound.Play("weapons/weapon_ttt_enderpearl/teleport.mp3",data.HitPos)

	timer.Simple(0, function()
		ply:SetPos(self:GetPos() - self:GetAngles():Forward():GetNormalized() * 60) --Lower the chances of getting stuck in a wall
	end)

	self:Remove();
end
