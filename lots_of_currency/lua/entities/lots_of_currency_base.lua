local AddCSLuaFile = AddCSLuaFile
local Vector = Vector
local GetConVar = GetConVar
local Material = Material
local CurTime = CurTime
local SafeRemoveEntityDelayed = SafeRemoveEntityDelayed
local ents_Create = SERVER and ents.Create
local math_abs = math.abs
local math_random = math.random
local math_sin = math.sin
local math_log = math.log
local math_pi = math.pi
local cam_Start3D = CLIENT and cam.Start3D
local render_SetMaterial = CLIENT and render.SetMaterial
local render_DrawSprite = CLIENT and render.DrawSprite
local cam_End3D = CLIENT and cam.End3D

AddCSLuaFile()


ENT.Type 			          = "anim"
ENT.Base 			          = "base_entity"
--3D base uses "base_gmodentity" idk if that's better
ENT.PrintName 			    = "Lots of Currency 2D Base"
ENT.Author 			        = "EntranceJew"
ENT.Contact             = "Good Luck!"
ENT.Information 		    = "You shouldn't be seeing this!"

ENT.Spawnable 			    = false
ENT.AdminSpawnable      = false
ENT.Category			      = "Lots of Currency"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

-- [[ real shit ]]
ENT.Model               = nil
ENT.SpriteMaterial	    = nil
ENT.SpriteColor			    = color_white
ENT.Worth				        = 1
ENT.ShouldDespawn       = false
ENT.ShouldBounce        = false
ENT.EnergeticBounce     = false
ENT.EnergeticBounceVel  = 50
ENT.BounceDecay         = 0.5           -- ->new<-
ENT.SpawnNoises		      = nil
ENT.BounceNoises		    = nil
ENT.BounceNoisePitch    = 125           -- ->new<-
ENT.CollectNoises		    = nil
ENT.CollectNoisePitch   = 100
ENT.HullSize            = 16
ENT.NoSelfCollide       = false
ENT.NoShadow            = true
ENT.DoCam3D             = false         -- ->new<-

ENT.Unicorn 			      = false

ENT.DespawnTime         = 0
ENT.FlickerTime         = 0
ENT.FlickerFrequency    = 0             -- ->new<-
ENT.Bounces             = 0
ENT.BouncesTotal        = 0             -- ->new<-
ENT.BounceForce         = 0             -- ->new<-

local vector_one = Vector(1, 1, 1)

function ENT:Initialize() --CL/SV
  local dsperiod = GetConVar("sv_loc_despawn_period"):GetFloat()
  self.ShouldDespawn = dsperiod > 0

  if self.SpriteMaterial then
    self.InternalMaterial = Material(self.SpriteMaterial)
  end
  if self.NoShadow then
    self:DrawShadow(false)
  end
  if self.SpriteColor then
    self:SetColor(self.SpriteColor)
  end
  if CLIENT then
    self:GetNoise(self, self.SpawnNoises)
    local cr = CurTime()
    self.DespawnTime = cr + dsperiod
    self.FlickerTime = cr + dsperiod * GetConVar("sv_loc_flicker_ratio"):GetFloat()
    self.FlickerFrequency = GetConVar("sv_loc_flicker_frequency"):GetFloat()
  end

  if SERVER then
    local adjustedsize = self.HullSize / 2
    if self.Model ~= nil then
      self:SetModel( self.Model )
      if self.ModelScale then
        self:SetModelScale( self.ModelScale )
      end
      if self.Skin then
        self:SetSkin(self.Skin)
      end
      self:SetMoveType( MOVETYPE_VPHYSICS )
      self:SetSolid( SOLID_VPHYSICS )
      self:PhysicsInit( SOLID_VPHYSICS )
    else
      self:SetModel("models/dav0r/hoverball.mdl")
      self:SetCollisionBounds( vector_one * -adjustedsize, vector_one * adjustedsize)
      self:PhysicsInitSphere( adjustedsize, "metal" )
    end
    -- from lego and 3D base
    self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
    -- self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
    -- from 3D base:
    -- self:SetUseType( SIMPLE_USE )
    -- self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

    --from 3D base:
    self:SetTrigger(true)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
      phys:Wake()
      phys:SetBuoyancyRatio(0)
    end

    if self.ShouldBounce then
      self.Bounces = GetConVar("sv_loc_bounce_count"):GetInt()
      self.BouncesTotal = self.Bounces
      self.BounceForce = GetConVar("sv_loc_bounce_force"):GetFloat()
    end

    if self.ShouldDespawn then
      SafeRemoveEntityDelayed(self, dsperiod)
    end
  end
end

function ENT:SpawnFunction( ply, tr, ClassName ) --SV
  if ( !tr.Hit ) then return end

  -- from 3D base:
  local ent = ents_Create( ClassName )

  local SpawnAng = ply:EyeAngles()
  SpawnAng.p = 0
  SpawnAng.y = SpawnAng.y + 90
  ent:SetAngles( SpawnAng )
  local SpawnPos = tr.HitPos + tr.HitNormal * self.HullSize
  ent:SetPos( SpawnPos )

  ent:Spawn()
  ent:Activate()

  return ent
end

function ENT:StartTouch(ent) --SV
  if ent and ent:IsPlayer() and GetConVar("sv_loc_allow_touch"):GetBool() then
    self:CurrencyGrabbed(ent)
  end
end
function ENT:Use(ent)
  if ent and ent:IsPlayer() and GetConVar("sv_loc_allow_use"):GetBool() then
    self:CurrencyGrabbed(ent)
  end
end

function ENT:PhysicsCollide(data,physobj) --SV
  -- lego stud behavior
  if self.NoSelfCollide and data.HitEntity.Base == self.Base then
    return
  end

  if self.ShouldBounce then
    if self.Bounces > 0 then
      if vector_up:Dot(-data.HitNormal) > 0 then
        local phys = self:GetPhysicsObject()
        local multiplier = self.Bounces / self.BouncesTotal
        local force = vector_up * (phys:GetMass() * self.BounceForce * multiplier)
        phys:ApplyForceCenter(force)
        self.Bounces = self.Bounces - 1
        self:GetNoise(self, self.BounceNoises, nil, self.BounceNoisePitch)
      end
    else
      self:GetPhysicsObject():Sleep()
    end
  end

  if self.EnergeticBounce and math_abs(data.OurOldVelocity.z) > self.EnergeticBounceVel then
    self:GetNoise(self, self.BounceNoises, nil, self.BounceNoisePitch)

    --physobj:AddVelocity( -data.HitNormal * data.OurOldVelocity:Length() * self.BounceDecay)
  end

  if !self.EnergeticBounce and !self.ShouldBounce then
    self:GetNoise(self, self.BounceNoises, nil, self.BounceNoisePitch)
  end
end

function ENT:GetNoise(emitTarget, noiseTable, soundLevel, pitchPercent, volume, channel)
  if noiseTable ~= nil then
    local noise = noiseTable[ math_random( #noiseTable ) ]
    emitTarget:EmitSound(noise, soundLevel or 75, pitchPercent or 100, volume or 1, channel or CHAN_AUTO)
  end
end

function ENT:CurrencyGrabbed(GrabEntity)
  if GrabEntity:IsPlayer() then
    -- TODO: try to find some way to implement repeating noise bings without awful side-effects
    --[[
      if self.Worth > 1 and self.MultiCollectNoise then
        for i = 1, self.Worth do
          timer.Simple(i * 0.05 - 0.05, function()
            self:GetNoise(GrabEntity, self.CollectNoises, 75, self.CollectNoisePitch or 100, 1, CHAN_AUTO)
            self:DoObtainEffect(GrabEntity, 1)
          end)
        end
      end
    ]]

    self:GetNoise(GrabEntity, self.CollectNoises, nil, self.CollectNoisePitch)

    local worth = self.Worth
    if ( GetConVar( "sv_loc_award_armor_multiplier" ):GetFloat() > 0 ) then
      local dal = GetConVar( "sv_loc_limit_armor" ):GetBool()
      local av = GrabEntity:Armor()
      if dal then
        local a_l = GrabEntity:GetMaxArmor()
        local al = GetConVar( "sv_loc_limit_armor_upper" ):GetFloat()
        if al > 0 then a_l = al end
        if av < a_l then
          GrabEntity:SetArmor( math.min( av + worth, a_l ) )
        end
      else
        GrabEntity:SetArmor( av + worth )
      end
    end
    if ( GetConVar( "sv_loc_award_health_multiplier" ):GetFloat() > 0 ) then
      local dhl = GetConVar( "sv_loc_limit_health" ):GetBool()
      local hv = GrabEntity:Health()
      if dhl then
        local h_l = GrabEntity:GetMaxHealth()
        local hl = GetConVar( "sv_loc_limit_health_upper" ):GetFloat()
        if hl > 0 then h_l = hl end
        if hv < h_l then
          GrabEntity:SetHealth( math.min( hv + worth, h_l ) )
        end
      else
        GrabEntity:SetHealth( hv + worth )
      end
    end
    if ( GetConVar( "sv_loc_award_money_multiplier" ):GetFloat() > 0 and GrabEntity.getDarkRPVar ) then
      local dml = GetConVar( "sv_loc_limit_money" ):GetBool()
      local mv = GrabEntity:getDarkRPVar("money")
      if dml then
        local m_l = math.huge
        local ml = GetConVar( "sv_loc_limit_money_upper" ):GetFloat()
        if ml > 0 then m_l = ml end
        if mv < m_l then
          GrabEntity:setDarkRPVar( "money", math.min( mv + worth, m_l ) )
        end
      else
        GrabEntity:setDarkRPVar( "money", mv + worth )
      end
    end

    -- lego stuff
    GrabEntity:SetNWInt("LotsOfCurrencyWorth", GrabEntity:GetNWInt("LotsOfCurrencyWorth", 0) + worth)

    -- generic
    self:Remove()
  end
end

function ENT:DrawTranslucent() --CL
  local v = 1
  local cr = CurTime()
  if self.ShouldDespawn and cr > self.FlickerTime then
    local x = cr - self.DespawnTime
    --v = math.abs(x) * math.sin( math.pi * math.log(math.abs(x), GetConVar("sv_loc_flicker_frequency"):GetFloat()) )
    v = math_sin( math_pi * math_log(-x, self.FlickerFrequency))
  end

  if v > 0 then
    if self.Model ~= nil then
      self:DrawModel()
    else
      if self.DoCam3D then cam_Start3D() end
      render_SetMaterial( self.InternalMaterial )
      local hs = self.HullSize
      render_DrawSprite( self:GetPos(), hs, hs, self.SpriteColor )
      if self.DoCam3D then cam_End3D() end
    end
  end
end
