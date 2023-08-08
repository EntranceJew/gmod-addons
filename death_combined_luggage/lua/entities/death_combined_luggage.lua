ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Death: Combined Luggage"
ENT.Category		= "Other"

ENT.Spawnable		= true
ENT.AdminOnly = true
ENT.DoNotDuplicate = false

local dprint = function(...)
  if GetConVar("sv_dcl_debug_print"):GetBool() then
    print(unpack({...}))
  end
end

local ammo_lookup = {
  item_ammo_smg1_grenade = {"SMG1_Grenade", 1},
  item_ammo_smg1 = {"SMG1", 45},
  item_ammo_smg1_large = {"SMG1", 225},
  item_box_buckshot = {"Buckshot", 20},
  item_rpg_round = {"RPG_Round", 1},
  item_ammo_pistol_large = {"Pistol", 100},
  item_ammo_pistol = {"Pistol", 20},
  item_ammo_crossbow = {"XBowBolt", 6},
  item_ammo_ar2_altfire = {"AR2AltFire", 1},
  item_ammo_ar2 = {"AR2", 20},
  item_ammo_ar2_large = {"AR2", 100},
  item_ammo_357 = {"357", 6},
  item_ammo_357_large = {"357", 20},

  -- arccw_ammo_smg1 = {"SMG1", 60},
  -- arccw_ammo_smg1_large = {"SMG1", 300},
  -- arccw_ammo_357 = {"357", 12},
  -- arccw_ammo_357_large = {"357", 60},
  -- arccw_ammo_pistol = {"Pistol", 40},
  -- arccw_ammo_pistol_large = {"Pistol", 200},
  -- arccw_ammo_ar2 = {"AR2", 30},
  -- arccw_ammo_ar2_large = {"AR2", 150},
  -- arccw_ammo_smg1_grenade = {"SMG1_Grenade", 1},
  -- arccw_ammo_smg1_grenade_large = {"SMG1_Grenade", 5},
  -- arccw_ammo_buckshot = {"Buckshot", 20},
  -- arccw_ammo_buckshot_large = {"Buckshot", 100},
  -- arccw_ammo_sniper = {"SniperPenetratedRound", 10},
  -- arccw_ammo_sniper_large = {"SniperPenetratedRound", 50},

  ammo_357 = {"357Round", 6},
  ammo_crossbow = {"XBowBoltHL1", 5},
  ammo_glockclip = {"9mmRound", 18},
  ammo_9mmbox = {"9mmRound", 200},
  ammo_mp5clip = {"9mmRound", 50},
  ammo_mp5grenades = {"MP5_Grenade", 2},
  ammo_rpgclip = {"RPG_Rocket", 2},
  ammo_buckshot = {"BuckshotHL1", 12},
  ammo_gaussclip = {"Uranium", 20},

  --[[
		[ 1] = "AR2",
		[ 2] = "AR2AltFire",
		[ 3] = "Pistol",
		[ 4] = "SMG1",
		[ 5] = "357",
		[ 6] = "XBowBolt",
		[ 7] = "Buckshot",
		[ 8] = "RPG_Round",
		[ 9] = "SMG1_Grenade",
		[10] = "Grenade",
		[11] = "slam",
		[12] = "AlyxGun",
		[13] = "SniperRound",
		[14] = "SniperPenetratedRound",
		[15] = "Thumper",
		[16] = "Gravity",
		[17] = "Battery",
		[18] = "GaussEnergy",
		[19] = "CombineCannon",
		[20] = "AirboatGun",
		[21] = "StriderMinigun",
		[22] = "HelicopterGun",
		[23] = "9mmRound",
		[24] = "357Round",
		[25] = "BuckshotHL1",
		[26] = "XBowBoltHL1",
		[27] = "MP5_Grenade",
		[28] = "RPG_Rocket",
		[29] = "Uranium",
		[30] = "GrenadeHL1",
		[31] = "Hornet",
		[32] = "Snark",
		[33] = "TripMine",
		[34] = "Satchel",
		[35] = "12mmRound",
		[36] = "StriderMinigunDirect",
		[37] = "CombineHeavyCannon",
		[38] = "arccw_base_nade",
		[39] = "arccw_go_nade_flash",
		[40] = "arccw_go_nade_frag",
		[41] = "arccw_go_nade_incendiary",
		[42] = "arccw_go_nade_knife",
		[43] = "arccw_go_nade_molotov",
		[44] = "arccw_go_nade_smoke",
		[45] = "arccw_go_taser"
  ]]
}

if SERVER then
  AddCSLuaFile()

  function ENT:SpawnFunction(ply, tr)

    if (!tr.Hit) then return end

    local SpawnPos = tr.HitPos + tr.HitNormal * 2

    local ent = ents.Create("death_combined_luggage")

    ent:SetPos(SpawnPos)
    ent:Spawn()
    ent:Activate()

    ent.Data = ent.Data or {}
    ent.WillDespawn = false

    return ent
  end

  function ENT:Initialize()
    self:SetModel(GetConVar("sv_dcl_luggage_model"):GetString() or "models/props_c17/suitcase_passenger_physics.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetTrigger(true)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    self:DrawShadow(false)

    constraint.Keepupright( self, self:GetAngles(), 0, 50000 )

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
      phys:Wake()
      phys:SetMass(GetConVar("sv_dcl_luggage_mass"):GetFloat())
    end
  end

  function ENT:StartTouch(v)
    if !IsValid(v) then return end
    print("touched a thing", v:GetClass())
    PrintTable(baseclass.Get(v:GetClass()))
    if (v:IsPlayer() and v:Alive()) or (v:IsNPC() and v:Health() > 0) then
      dprint(v, "picked up a backpack!")
      local initRemoved = DeathCombinedLuggage.ComputeScore(self.Data)
      --[[local removed =]] DeathCombinedLuggage.Deserialize(self.Data, v, true)
      local removed = DeathCombinedLuggage.ComputeScore(self.Data)

      if removed < initRemoved and removed > 0 then
        self:EmitSound("weapons/357/357_reload3.wav")
      elseif removed <= 0 then
        self:EmitSound("weapons/357/357_spin1.wav")
        self:Remove()
      end
    end
  end

  function ENT:PhysicsCollide(data, phys)
    if !IsValid(data.HitEntity) then
      return
    end
    local hit_ent = data.HitEntity
    local hit_ent_class = data.HitEntity:GetClass()

    -- only one must prevail
    local the_winner = false
    if hit_ent.WillDespawn and !self.WillDespawn then
      the_winner = true
    elseif hit_ent.WillDespawn == self.WillDespawn and hit_ent:EntIndex() > self:EntIndex() then
      the_winner = true
    end

    if hit_ent_class == "death_combined_luggage" and the_winner then
      dprint(self, "just phys'd", hit_ent)
      self.Data = DeathCombinedLuggage.Merge(self.Data, hit_ent.Data)
      self:EmitSound("weapons/357/357_spin1.wav")
      hit_ent:Remove()
      return
    end

    if hit_ent_class == "item_battery" then
      self.Data.Armor = (self.Data.Armor or 0) + 15
      self:EmitSound("weapons/357/357_spin1.wav")
      hit_ent:Remove()
      return
    end

    for ent_name, ammo_data in pairs(ammo_lookup) do
      if ent_name == hit_ent_class then
        self.Data.Ammo = self.Data.Ammo or {}
        self.Data.Ammo[ammo_data[1]] = (self.Data.Ammo[ammo_data[1]] or 0) + ammo_data[2]
        self:EmitSound("weapons/357/357_spin1.wav")
        hit_ent:Remove()
        return
      end
    end

    if hit_ent:IsWeapon() then
      local wep = hit_ent
      -- TODO: make this into its own function in the autorun rather than duplicate it here
      if GetConVar("sv_dcl_pack_arccw_attachments"):GetBool() and wep.ArcCW then
        self.Data.Attachments = self.Data.Attachments or {}
        for _, attachment in ipairs(wep.Attachments) do
          if attachment.Installed ~= nil and !ArcCW.AttachmentTable[attachment.Installed].Free then
            self.Data.Attachments[attachment.Installed] = (self.Data.Attachments[attachment.Installed] or 0) + 1
          end
        end
      end

      if GetConVar("sv_dcl_pack_ammo"):GetBool() and DeathCombinedLuggage.CheckPrimary(wep) then
        self.Data.Ammo = self.Data.Ammo or {}
        self.Data.Ammo[wep:GetPrimaryAmmoType()] = (self.Data.Ammo[wep:GetPrimaryAmmoType()] or 0) + math.max(0, wep:Clip1())
      end

      if GetConVar("sv_dcl_pack_ammo"):GetBool() and DeathCombinedLuggage.CheckSecondary(wep) then
        self.Data.Ammo = self.Data.Ammo or {}
        self.Data.Ammo[wep:GetSecondaryAmmoType()] = (self.Data.Ammo[wep:GetSecondaryAmmoType()] or 0) + math.max(0, wep:Clip2())
      end

      if GetConVar("sv_dcl_pack_weapons"):GetBool() and wep:IsValid() then
        self.Data.Weapons = self.Data.Weapons or {}
        self.Data.Weapons[wep:GetClass()] = (self.Data.Weapons[wep:GetClass()] or 0) + 1
        self:EmitSound("weapons/357/357_spin1.wav")
        hit_ent:Remove()
      end

      if hit_ent:IsScripted() then
        print("hit a SWEP", hit_ent_class)
        PrintTable(baseclass.Get(hit_ent_class))
      else
        print("hit a base weapon", hit_ent_class)
      end
    end

    if hit_ent.Base == "arccw_att_base" and hit_ent.ShortName ~= nil and !ArcCW.AttachmentTable[hit_ent.ShortName].Free then
      self.Data.Attachments = self.Data.Attachments or {}
      self.Data.Attachments[hit_ent.ShortName] = (self.Data.Attachments[hit_ent.ShortName] or 0) + 1
      self:EmitSound("weapons/357/357_spin1.wav")
      hit_ent:Remove()
    end

    if hit_ent.Base == "arccw_ammo" and hit_ent.AmmoCount > 0 then
      self.Data.Ammo = self.Data.Ammo or {}
      local ammo_type = game.GetAmmoID(hit_ent.AmmoType)
      self.Data.Ammo[ammo_type] = (self.Data.Ammo[ammo_type] or 0) + hit_ent.AmmoCount
      self:EmitSound("weapons/357/357_spin1.wav")
      hit_ent:Remove()
    end
  end
end

if CLIENT then
  function ENT:Draw()
    self:DrawModel()
  end
end