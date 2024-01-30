-- Frag grenade projectile

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model( "models/weapons/ice_grenade/icegrenadew.mdl" )

AccessorFunc( ENT, "radius", "Radius", FORCE_NUMBER )
AccessorFunc( ENT, "dmg", "Dmg", FORCE_NUMBER )

function ENT:Initialize()
   if not self:GetRadius() then self:SetRadius( 250 ) end
   if not self:GetDmg() then self:SetDmg( 1 ) end

   util.PrecacheSound( "explode_3" )

   return self.BaseClass.Initialize( self )
end

function ENT:FreezeAll()
  local phys = self:GetPhysicsObject()
  if ( IsValid( phys ) ) then phys:Wake() end
  local grenadepos = self:GetPos()
  local colIce = Color( 87, 230, 230, 255)
  for k, v in pairs(ents.FindInSphere( grenadepos, 300 )) do
    if IsValid(v)  and v:IsPlayer() then
      v:Freeze(true)
      v:SetColor( colIce )
      timer.Simple( 8, function()
        v:Freeze( false)
        v:SetColor(255,255,255,255) end)
    end
  end
end

function ENT:Explode( tr )
   if SERVER then
      self:SetNoDraw( true )
      self:SetSolid( SOLID_NONE )

      -- Pull out of the surface
      if tr.Fraction != 1.0 then
         self:SetPos( tr.HitPos + tr.HitNormal * 0.6 )
      end

      local pos = self:GetPos()

      if util.PointContents( pos ) == CONTENTS_WATER then
         self:Remove()
         return
      end

      local effect = EffectData()
      effect:SetStart( pos )
      effect:SetOrigin( pos )
      effect:SetScale( self:GetRadius() * 0.3 )
      effect:SetRadius( self:GetRadius() )
      effect:SetMagnitude( self.dmg )

      self:EmitSound("weapons/ice_grenade/ice_explosion.wav", 85, 90, 1, CHAN_AUTO)
      ParticleEffect( "ice_explosion", self:GetPos(), Angle( 0, 0, 0 ) )

      if tr.Fraction != 1.0 then
         effect:SetNormal( tr.HitNormal )
      end

      util.Effect( "Explosion", effect, true, true )

      -- util.BlastDamage( self, self:GetThrower(), pos, self:GetRadius(), self:GetDmg() )
      local ice =  ents.FindInSphere( pos, self:GetRadius())
      for key, value in ipairs(ice) do
        self:FreezeObject(value)
      end
      self:SetDetonateExact( 0 )

      self:Remove()
   else
      local spos = self:GetPos()
      local trs = util.TraceLine( { start=spos + Vector( 0, 0, 64 ), endpos=spos + Vector( 0, 0, -128 ), filter=self } )
      util.Decal( "Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal )

      self:SetDetonateExact( 0 )
   end
end



local mat = "effects/freeze_overlayeffect01"
local FreezeColor = Color(100,150,255)
local function unfreeze(ent)
  ent.m_Freeze = false
  ent:SetMaterial(ent.m_Material)
  if ent:IsPlayer() then
    ent:Freeze(false)
    ent:SendLua("fl_fr=false")
  elseif ent:IsNPC() then
    ent:SetSchedule(SCHED_WAKE_ANGRY)
  elseif ent.Type == "nextbot" then
    ent.BodyUpdate = ent.m_BodyUpdate
    ent.m_BodyUpdate = nil
    ent.BehaveUpdate = ent.m_BehaveUpdate
    ent.m_BehaveUpdate = nil
  end
  local effectdata = EffectData()
  effectdata:SetOrigin( ent:LocalToWorld(ent:OBBCenter()))
  local scale = 4 + math.Rand(-0.25,1.25)
  local po = ent:GetPhysicsObject()
  if IsValid(po) then
    scale = scale + po:GetMass()*0.001
  end
  effectdata:SetScale( scale )
  effectdata:SetMagnitude( 2 )
  util.Effect( "GlassImpact", effectdata, true, true )
  ent:EmitSound("physics/glass/glass_largesheet_break"..math.random(1,3)..".wav")
end
local UnFreeze = {}
local pairs,IsValid,CurTime = pairs,IsValid,CurTime
hook.Add("Tick","UnfreezeEnts",function()
  for k,v in pairs(UnFreeze) do
    if IsValid(k) && v <= CurTime() then
      UnFreeze[k] = nil
      unfreeze(k)
    end
  end
end)
hook.Add("EntityTakeDamage","DealWithDamage",function(ent,dmg)
  if ent.m_Freeze then
    dmg:ScaleDamage(math.Rand(1.5,2.25))
    if dmg:GetDamage() > ent:Health() then
      dmg:ScaleDamage(100)
      local effectdata = EffectData()
      effectdata:SetOrigin(ent:LocalToWorld(ent:OBBCenter()))
      local force = dmg:GetDamageForce()
      effectdata:SetNormal(force:GetNormalized())
      effectdata:SetEntity(ent)
      effectdata:SetDamageType(DMG_DROWN)
      local scale,po = 1,ent:GetPhysicsObject()
      if IsValid(po) then
        scale = scale + po:GetMass()/50
      end
      effectdata:SetScale(scale)
      util.Effect( "freeze_gibs", effectdata, true, true )
      ent:EmitSound("physics/glass/glass_largesheet_break"..math.random(1,3)..".wav")
      unfreeze(ent)
      UnFreeze[ent] = nil
      if ent:IsPlayer() then
        hook.Call("PlayerDeath",GAMEMODE,ent,dmg:GetInflictor(),dmg:GetAttacker() )
        ent:KillSilent()
        local rag = ent:GetRagdollEntity()
        if IsValid(rag) then
          rag:Remove()
        end
      else
        hook.Call("OnNPCKilled",GAMEMODE,ent,dmg:GetAttacker(),dmg:GetInflictor() )
        ent:Remove()
      end
      return true
    end
  end
end)
local function_origin = function() end
local behaveupdate = function(self)
  if ( !self.BehaveThread ) then return end
  self:SetPlaybackRate( 0 );
end
function ENT:FreezeObject(ent)
  UnFreeze[ent] = CurTime()+math.random(3,5)
  if !ent.m_Freeze then
    ent.m_Material = ent:GetMaterial()
    ent:SetMaterial(mat)
    ent.m_Freeze = true
    if ent:IsPlayer() then
      ent:Freeze(true)
      ent:SendLua("fl_fr=true")
    elseif ent:IsNPC() then
      ent:StopMoving()
      ent:SetSchedule(SCHED_NPC_FREEZE)
    elseif ent.Type == "nextbot" then
      ent.m_BodyUpdate = ent.BodyUpdate
      ent.BodyUpdate = function_origin
      ent.m_BehaveUpdate = ent.BehaveUpdate
      ent.BehaveUpdate = behaveupdate
    else
      return
    end
  end
end
