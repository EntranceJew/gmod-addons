AddCSLuaFile()

DeathCombinedLuggage = {
  -- PropText = ""
}

--[[
  TODO: use JewUI for this stuff
  TODO: toggle max values
  TODO: add a way to absorb other arbitrary entities: item_healthvial, item_battery, item_ammo_ar2_altfire
]]

--[[
  CHANGELOG:
  Features:
  [list]
  [*] Made awarded armor values obey "GetMaxArmor()"
  [*] Allowed spawning the entity from the spawn menu as "Other => Death: Combined Luggage" or "death_combined_luggage"
  [*] 
  [/list]
]]
-- https://www.gametracker.com/search/garrysmod/?search_by=server_variable&search_by2=sv_dcl_drop_on_player_death&query=1&loc=_all&sort=3&order=DESC
local con_struct = {
  meta = {
    prefix = "dcl",
    title = "DeathCombinedLuggage",
  },
  toolmenus = {
    {
      tab = "Utilities",
      heading = "Admin",
      uid = "DeathCombinedLuggage_AdminOptions",
      titlebar = "Death: Combined Luggage",
      prefix = "sv",
      sets = {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED},
      contents = {
        {"category", "general", "General", {
          {"bool", "drop_on_player_death", "Should luggage spawn when a player dies?", 1, 0, 1},
          {"bool", "drop_on_npc_death", "Should luggage spawn when an NPC dies?", 1, 0, 1},
        }},
        {"category", "physical_traits", "Physical Traits", {
          {"string", "luggage_model", "What model should the luggage use?", "models/props_c17/suitcase_passenger_physics.mdl"},
          {"float", "luggage_mass", "How heavy is luggage? Useful for preventing pocketing.", 101, 0, nil},
          {"float", "luggage_buoyancy_ratio", "How hard should luggage fight to stay on top of water?", 2, 0, nil},
          {"float", "despawn_time", "How long should it take for luggage to despawn?", 120, 0, nil},
          {"float", "spawn_height", "How high from the point of death should luggage spawn?", 64, 0, nil},
        }},
        {"category", "features_pack", "Features: Pack", {
          {"bool", "pack_armor", "Persist spare armor?", 1, 0, 1},
          {"bool", "pack_weapons", "Persist weapons?", 1, 0, 1},
          {"bool", "pack_ammo", "Persist ammo and weapon ammo?", 1, 0, 1},
          {"bool", "pack_arc_medshots", "Persist med shots?", 1, 0, 1},
          {"bool", "pack_arc_nvg", "Persist Arc Night Vision Goggles?", 1, 0, 1},
          {"bool", "pack_arccw_attachments", "Persist ArcCW Attachment Inventory?", 1, 0, 1, },
          {"bool", "pack_darkrp_money", "Persist DarkRP money?", 1, 0, 1},
          {"bool", "pack_darkrp_pocket", "Persist DarkRP pocket?", 1, 0, 1},
        }},
        {"category", "features_strip", "Features: Strip", {
          {"bool", "strip_armor", "Strip spare armor?", 1, 0, 1},
          {"bool", "strip_weapons", "Strip weapons?", 1, 0, 1},
          {"bool", "strip_ammo", "Strip ammo and weapon ammo?", 1, 0, 1},
          {"bool", "strip_arc_medshots", "Strip med shots?", 1, 0, 1},
          {"bool", "strip_arc_nvg", "Strip Arc Night Vision Goggles?", 1, 0, 1},
          {"bool", "strip_arccw_attachments", "Strip ArcCW Attachment Inventory?", 1, 0, 1},
          {"bool", "strip_darkrp_money", "Strip DarkRP money?", 1, 0, 1},
          {"bool", "strip_darkrp_pocket", "Strip DarkRP pocket?", 1, 0, 1},
        }},
        {"category", "debug", "Debug", {
          {"bool", "debug_print", "Should we print extra messages for debugging?", 0, 0, 1, },
        }},
      },
    },
  },
}

local dprint = function(...)
  if GetConVar("sv_dcl_debug_print"):GetBool() then
    print(unpack({...}))
  end
end

for tm = 1, #con_struct.toolmenus do
  local tmenu = con_struct.toolmenus[tm]
  for i = 1, #tmenu.contents do
    local cm = tmenu.contents[i]
    for j = 1, #cm[4] do
      local v = cm[4][j]
      CreateConVar(
        tmenu.prefix .. "_" .. con_struct.meta.prefix .. "_" .. v[2],
        v[4],
        tmenu.sets,
        v[3],
        v[5],
        v[6]
      )
    end
  end
end

DeathCombinedLuggage.ConVars = con_struct

function DeathCombinedLuggage.CheckPrimary(wep)
  return wep:GetPrimaryAmmoType() > -1
end

function DeathCombinedLuggage.CheckSecondary(wep)
  return wep:GetSecondaryAmmoType() > -1 and wep:Clip2() >= 0
end

function DeathCombinedLuggage.Serialize(ply)
  local box = {}

  -- armor
  if GetConVar("sv_dcl_pack_armor"):GetBool() and ply.Armor then
    box.Armor = ply:Armor()
  end

  -- med shots
  if GetConVar("sv_dcl_pack_arc_medshots"):GetBool() and ply.ArcticMedShots_Inv ~= nil then
    box.MedShots = table.Copy(ply.ArcticMedShots_Inv or {})
  end

  -- goggles
  if GetConVar("sv_dcl_pack_arc_nvg"):GetBool() and ArcticNVGs_GetPlayerGoggles and ArcticNVGs_GetPlayerGoggles(ply) ~= nil then
    box.Goggles = ArcticNVGs_GetPlayerGoggles(ply).ShortName
  end

  -- money
  if GetConVar("sv_dcl_pack_darkrp_money"):GetBool() and DarkRP and ply.getDarkRPVar then
    box.Money = ply:getDarkRPVar("money")
  end

  -- pocket 
  if GetConVar("sv_dcl_pack_darkrp_pocket"):GetBool() and DarkRP and ply.darkRPPocket then
    box.Pocket = table.Copy(ply.darkRPPocket or {})
  end

  -- ammo
  if GetConVar("sv_dcl_pack_ammo"):GetBool() and ply.GetAmmo then
    box.Ammo = ply:GetAmmo() or {}
  else
    box.Ammo = {}
  end

  -- attachments
  if GetConVar("sv_dcl_pack_arccw_attachments"):GetBool() then
    box.Attachments = {}
    if ply.ArcCW_AttInv then
      for attachment, quantity in pairs(ply.ArcCW_AttInv or {}) do
        if !ArcCW.AttachmentTable[attachment].Free then
          box.Attachments[attachment] = (box.Attachments[attachment] or 0) + quantity
        end
      end
    end
  end

  -- weapons
  box.Weapons = {}
  local weps = {}
  if ply.GetWeapons then
    weps = ply:GetWeapons()
  end
  for i = 1, #weps do
    local wep = weps[i]
    if GetConVar("sv_dcl_pack_arccw_attachments"):GetBool() and wep.ArcCW then
      for _, attachment in ipairs(wep.Attachments) do
        if attachment.Installed ~= nil and !ArcCW.AttachmentTable[attachment.Installed].Free then
          box.Attachments[attachment.Installed] = (box.Attachments[attachment.Installed] or 0) + 1
        end
      end
    end

    if GetConVar("sv_dcl_pack_ammo"):GetBool() and DeathCombinedLuggage.CheckPrimary(wep) then
      box.Ammo[wep:GetPrimaryAmmoType()] = (box.Ammo[wep:GetPrimaryAmmoType()] or 0) + math.max(0, wep:Clip1())
    end

    if GetConVar("sv_dcl_pack_ammo"):GetBool() and DeathCombinedLuggage.CheckSecondary(wep) then
      box.Ammo[wep:GetSecondaryAmmoType()] = (box.Ammo[wep:GetSecondaryAmmoType()] or 0) + math.max(0, wep:Clip2())
    end

    local should = true
    if DarkRP then
      if ply:IsNPC() then
        should = true
      else
        should = should and hook.Call("canDropWeapon", GAMEMODE, ply, wep)
      end
    end
    if GetConVar("sv_dcl_pack_weapons"):GetBool() and wep:IsValid() and should then
      box.Weapons[wep:GetClass()] = (box.Weapons[wep:GetClass()] or 0) + 1
    end
  end

  -- that's all folks
  return box
end

function DeathCombinedLuggage.Strip(ply)
  -- armor
  if GetConVar("sv_dcl_strip_armor"):GetBool() and ply.SetArmor then
    ply:SetArmor(0)
  end

  -- med shots
  if GetConVar("sv_dcl_strip_arc_medshots"):GetBool() then
    ply.ArcticMedShots_Inv = {}
  end

  -- goggles
  if GetConVar("sv_dcl_strip_arc_nvg"):GetBool() then
    ply:SetNWInt("nvg", 0)
  end

  -- money
  if GetConVar("sv_dcl_strip_darkrp_money"):GetBool() and ply.addMoney and ply.getDarkRPVar then
    ply:addMoney(-ply:getDarkRPVar("money"))
  end

  -- ammo
  if GetConVar("sv_dcl_strip_ammo"):GetBool() and ply.GetAmmo and ply.SetAmmo then
    for ammoID, ammoName in pairs(ply:GetAmmo() or {}) do
      ply:SetAmmo(0, ammoID)
    end
  end

  local weps = ply:GetWeapons()
  for i = 1, #weps do
    local wep = weps[i]

    if GetConVar("sv_dcl_strip_arccw_attachments"):GetBool() and wep.ArcCW then
      wep.Attachments = {}
    end

    if GetConVar("sv_dcl_strip_ammo"):GetBool() and DeathCombinedLuggage.CheckPrimary(wep) then
      dprint(IsValid(wep))
      dprint(wep.SetClip1)
      -- wep:SetClip1(0)
    end

    if GetConVar("sv_dcl_strip_ammo"):GetBool() and DeathCombinedLuggage.CheckSecondary(wep) then
      wep:SetClip2(0)
    end

    local should = true
    if DarkRP then
      if ply:IsNPC() then
        should = true
      else
        should = should and hook.Call("canDropWeapon", GAMEMODE, ply, wep)
      end
    end
    if GetConVar("sv_dcl_strip_weapons"):GetBool() and wep:IsValid() and should and ply.StripWeapon then
      ply:StripWeapon(wep:GetClass())
    end

    -- make NPCs forcibly drop that dumb shit
    if GetConVar("sv_dcl_strip_weapons"):GetBool() and ply:IsNPC() and IsValid(wep) then
      ply:DropWeapon(wep)
      if IsValid(wep) then
        wep:Remove()
      end
    end
  end

  -- attachments inventory
  if GetConVar("sv_dcl_strip_arccw_attachments"):GetBool() and ArcCW and ArcCW.PlayerSendAttInv then
    ply.ArcCW_AttInv = {}
    if ply:IsPlayer() then
      ArcCW:PlayerSendAttInv(ply)
    end
  end

  -- pocket 
  if GetConVar("sv_dcl_strip_darkrp_pocket"):GetBool() and ply.darkRPPocket then
    for k in pairs(ply.darkRPPocket or {}) do
      ply:removePocketItem(k)
    end
  end

  -- there we go
end

/*
  function DeathCombinedLuggage.OldSerializeAndStrip(ply)
    local box = {}
    -- armor
    box.Armor = ply:Armor()

    -- med shots
    box.MedShots = table.Copy(ply.ArcticMedShots_Inv or {})
    ply.ArcticMedShots_Inv = {}

    -- goggles
    local goggles = ArcticNVGs_GetPlayerGoggles(ply)
    if goggles ~= nil then
      box.Goggles = goggles.ShortName
      ply:SetNWInt("nvg", 0)
    end

    -- put money in the box
    local money = ply:getDarkRPVar("money")
    ply:addMoney(-money)
    box.Money = money

    -- put our loose ammo in the box
    -- local wep = ply:GetActiveWeapon()
    local ammo = ply:GetAmmo()
    local weps = ply:GetWeapons()
    box.Weapons = {}
    box.Attachments = {}
    for i = 1, #weps do
      local wep = weps[i]
      local canDrop = hook.Call("canDropWeapon", GAMEMODE, ply, wep)
      if wep:IsValid() and canDrop then
        -- put weapon attachments
        if wep.ArcCW then
          for _, attachment in ipairs(wep.Attachments) do
            print("att: packing from weapon", attachment.Installed)
            if attachment.Installed ~= nil and !ArcCW.AttachmentTable[attachment.Installed].Free then
              if box.Attachments[attachment.Installed] ~= nil then
                print("att: packing", attachment.Installed, "for quantity", box.Attachments[attachment.Installed] + 1, "did it cost anything?", !ArcCW.AttachmentTable[attachment].Free)
                box.Attachments[attachment.Installed] = box.Attachments[attachment.Installed] + 1
              else
                print("att: first time packing", attachment, "for quantity", 1, "did it cost anything?")
                box.Attachments[attachment.Installed] = 1
              end
            end
          end
        end

        if wep:GetPrimaryAmmoType() > -1 then
          local ammoAmount = (ammo[wep:GetPrimaryAmmoType()] or 0)
          print("unloading", ammoAmount, "of", game.GetAmmoName(wep:GetPrimaryAmmoType()))
          ammo[wep:GetPrimaryAmmoType()] = ammoAmount + wep:Clip1()
          wep:SetClip1(0)
        end

        if wep:GetSecondaryAmmoType() > -1 and wep:Clip2() >= 0 then
          local ammoAmount2 = (ammo[wep:GetSecondaryAmmoType()] or 0)
          ammo[wep:GetSecondaryAmmoType()] = ammoAmount2 + wep:Clip2()
          wep:SetClip2(0)
        end

        -- put weapons
        table.insert(box.Weapons, wep:GetClass())
        -- box.Weapons[wep:GetClass()] = true
      else
        print("could not drop", wep)
      end
    end
    box.Ammo = ammo

    -- put player attachment inventory
    for attachment, quantity in pairs(ply.ArcCW_AttInv or {}) do
      print("att: packing inventory", attachment, "for quantity", quantity, "did it cost anything?", !ArcCW.AttachmentTable[attachment].Free)
      if !ArcCW.AttachmentTable[attachment].Free then
        if box.Attachments[attachment] ~= nil then
          box.Attachments[attachment] = box.Attachments[attachment] + quantity
        else
          box.Attachments[attachment] = quantity
        end
        ArcCW:PlayerTakeAtt(ply, attachment, quantity)
      end
    end
    ArcCW:PlayerSendAttInv(ply)

    -- put pocket 
    box.Pocket = table.Copy(ply.darkRPPocket or {})
    for k in pairs(ply.darkRPPocket or {}) do
      ply:removePocketItem(k)
    end

    return box
  end
*/

function DeathCombinedLuggage.Deserialize(box, ply, woo)
  -- armor
  if box.Armor and ply.SetArmor and ply.Armor and ply.GetMaxArmor and ply:Armor() < ply:GetMaxArmor() then
    local missing = math.min(ply:GetMaxArmor() - ply:Armor(), box.Armor)
    box.Armor = box.Armor - missing
    print("=>", missing, box.Armor, ply:Armor())
    ply:SetArmor(ply:Armor() + missing)
  end

  -- med shots
  if !ply.ArcticMedShots_Inv then ply.ArcticMedShots_Inv = {} end
  for shotID, quantity in pairs(box.MedShots or {}) do
    if ply.ArcticMedShots_Inv[shotID] == nil then
      ply.ArcticMedShots_Inv[shotID] = 0
    end
    ply.ArcticMedShots_Inv[shotID] = (ply.ArcticMedShots_Inv[shotID] or 0) + quantity
  end
  if ply.IsPlayer and ply:IsPlayer() and ArcticMedShots_SyncPlayer then
    ArcticMedShots_SyncPlayer(ply)
  end

  -- goggles
  if box.Goggles ~= nil and ArcticNVGs_SetPlayerGoggles then
    ArcticNVGs_SetPlayerGoggles(ply, box.Goggles)
    box.Goggles = nil
  end

  -- money
  if box.Money and ply.addMoney then
    ply:addMoney(box.Money)
    box.Money = 0
  end

  -- attachment
  if box.Attachments and ArcCW then
    for attachment, quantity in pairs(box.Attachments or {}) do
      if !ArcCW.AttachmentTable[attachment].Free then
        ArcCW:PlayerGiveAtt(ply, attachment, quantity)
      end
    end
    if ply.IsPlayer and ply:IsPlayer() then
      ArcCW:PlayerSendAttInv(ply)
    end
    box.Attachments = nil
  end

  -- weapons
  if box.Weapons and ply.Give then
    for k, v in pairs(box.Weapons) do
      local wep = ply:Give(k, true)
      if wep and IsValid(wep) then
        box.Weapons[wep:GetClass()] = v - 1
      end
    end
  end

  -- ammo
  if box.Ammo and ply.GiveAmmo then
    local max_ammo = GetConVar("gmod_maxammo"):GetFloat()
    for ammoType, ammoAmount in pairs(box.Ammo) do
      local ammo_limit = -1
      if max_ammo > 0 then
        ammo_limit = max_ammo
      else
        local adat = game.GetAmmoData(game.GetAmmoID(ammoType))
        if adat.maxcarry then
          if type(adat.maxcarry) == "string" then
            local cv = GetConVar(adat.maxcarry)
            if IsValid(cv) then
              ammo_limit = cv:GetFloat()
            end
          elseif type(adat.maxcarry) == "number" then
            ammo_limit = adat.maxcarry
          end
        end
      end

      -- @TODO: check that we're only giving the max ammo
      if ply.GiveAmmo then
        ply:GiveAmmo(ammoAmount,ammoType)
      end
    end
    box.Ammo = {}
  end

  -- pocket
  if box.Pocket and DarkRP and ply.Team and RPExtraTeams then
    local job = ply.Team and ply:Team()
    local max = (RPExtraTeams[job] and RPExtraTeams[job].maxpocket) or GAMEMODE.Config.pocketitems
    for i = #box.Pocket, 1, -1 do
      local item = box.Pocket[i]
      if ply.darkRPPocket == nil then ply.darkRPPocket = {} end
      local fullness = table.Count(ply.darkRPPocket or {})
      -- print(fullness, max)
      if fullness >= max then break end
      -- print(item)
      table.insert(ply.darkRPPocket, item)
      -- local ent = deserialize(self, item)
      -- ent.USED = nil
      -- ply.darkRPPocket()
      table.remove(box.Pocket, i)
    end
    net.Start("DarkRP_Pocket")
      net.WriteTable(ply:getPocketItems())
    net.Send(ply)
  end
end

function DeathCombinedLuggage.ComputeScore(box)
  local score = 0

  -- armor
  if box.Armor then
    score = score + box.Armor
  end

  -- med shots
  if box.MedShots then
    for shotID, quantity in pairs(box.MedShots or {}) do
      score = score + quantity
    end
  end

  -- goggles
  if box.Goggles ~= nil then
    score = score + 1
  end

  -- money
  if box.Money then
    score = score + box.Money
  end

  -- attachment
  if box.Attachments then
    for attachment, quantity in pairs(box.Attachments or {}) do
      if !ArcCW.AttachmentTable[attachment].Free then
        score = score + quantity
      end
    end
  end

  -- weapons
  if box.Weapons then
    for k, v in pairs(box.Weapons) do
      score = score + v
    end
  end

  -- ammo
  if box.Ammo then
    for ammoType, ammoAmount in pairs(box.Ammo) do
      score = score + ammoAmount
    end
  end

  -- pocket
  if box.Pocket then
    score = score + #box.Pocket
  end

  return score
end

function DeathCombinedLuggage.Merge(box1, box2)
  -- armor
  box1.Armor = (box1.Armor or 0) + (box2.Armor or 0)

  -- med shots
  if box1.MedShots == nil and box2.MedShots ~= nil then
    box1.MedShots = table.Copy(box2.MedShots)
  else
    for shotID, quantity in pairs(box2.MedShots or {}) do
      if box1.MedShots[shotID] == nil then
        box1.MedShots[shotID] = 0
      end
      box1.MedShots[shotID] = (box1.MedShots[shotID] or 0) + quantity
    end
  end

  -- goggles
  -- if ArcticNVGs_GetPlayerGoggles and ArcticNVGs_GetPlayerGoggles(ply) ~= nil then
  --   box.Goggles = ArcticNVGs_GetPlayerGoggles(ply).ShortName
  -- end

  -- money
  box1.Money = (box1.Money or 0) + (box2.Money or 0)

  -- pocket 
  if box1.Pocket == nil and box2.Pocket ~= nil then
    box1.Pocket = table.Copy(box2.Pocket)
  else
    table.Add(box1.Pocket, box2.Pocket)
  end

  -- ammo
  if box1.Ammo == nil and box2.Ammo ~= nil then
    box1.Ammo = table.Copy(box2.Ammo)
  else
    for ammoID, quantity in pairs(box2.Ammo or {}) do
      if box1.Ammo[ammoID] == nil then
        box1.Ammo[ammoID] = 0
      end
      box1.Ammo[ammoID] = (box1.Ammo[ammoID] or 0) + quantity
    end
  end

  -- attachments
  if box1.Attachments == nil and box2.Attachments ~= nil then
    box1.Attachments = table.Copy(box2.Attachments)
  else
    for attachmentID, quantity in pairs(box2.Attachments or {}) do
      if box1.Attachments[attachmentID] == nil then
        box1.Attachments[attachmentID] = 0
      end
      box1.Attachments[attachmentID] = (box1.Attachments[attachmentID] or 0) + quantity
    end
  end

  -- weapons
  if box1.Weapons == nil and box2.Weapons ~= nil then
    box1.Weapons = table.Copy(box2.Weapons)
  else
    for weaponID, quantity in pairs(box2.Weapons or {}) do
      if box1.Weapons[weaponID] == nil then
        box1.Weapons[weaponID] = 0
      end
      box1.Weapons[weaponID] = (box1.Weapons[weaponID] or 0) + quantity
    end
  end

  -- that's all folks
  return box1
end

function DeathCombinedLuggage.SpawnFor(ent)
  local data = DeathCombinedLuggage.Serialize(ent)
  local score = DeathCombinedLuggage.ComputeScore(data)
  dprint(ent, "died with itemscore", score)
  if score <= 0 then
    return
  end
  local box = ents.Create("death_combined_luggage")
  box:SetPos(ent:GetPos() + Vector(0,0,GetConVar("sv_dcl_spawn_height"):GetFloat()))

  box.Data = data
  DeathCombinedLuggage.Strip(ent)

  box:Activate()
  box:Spawn()
  dprint("DCL:", box)
  local phys = box:GetPhysicsObject()
  if (phys:IsValid()) then
    phys:SetBuoyancyRatio(GetConVar("sv_dcl_luggage_buoyancy_ratio"):GetFloat())
    phys:SetVelocity(ent:GetVelocity())
  end

  local dst = GetConVar("sv_dcl_despawn_time"):GetFloat()
  if dst > 0 then
    box.WillDespawn = true
    timer.Simple(dst - 0.2, function() if IsValid(box) then
        local ed = EffectData()
        ed:SetOrigin( box:GetPos() )
        ed:SetEntity( box )
        util.Effect( "entity_remove", ed, true, true )
      end
    end)
    timer.Simple(dst, function() if IsValid(box) then box:Remove() end end)
  end
end

-- hook.Remove( "DoPlayerDeath", "DropWeapon")
-- hook.Remove( "OnNPCKilled", "DropWeapon")
hook.Add( "OnNPCKilled", "DeathCombinedLuggage_NPCKilled", function(npc, attacker, inflictor)
  if GetConVar("sv_dcl_drop_on_npc_death"):GetBool() then
    DeathCombinedLuggage.SpawnFor(npc)
  end
end )
hook.Add( "DoPlayerDeath", "DeathCombinedLuggage_PlayerKilled", function( ply, attacker, dmg )
  if GetConVar("sv_dcl_drop_on_player_death"):GetBool() then
    DeathCombinedLuggage.SpawnFor(ply)
  end
end )