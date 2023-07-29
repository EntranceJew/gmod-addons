AddCSLuaFile()
AddCSLuaFile("lots_of_currency/jewui.lua")
local JewUI = include("lots_of_currency/jewui.lua")

-- TODO: https://steamcommunity.com/sharedfiles/filedetails/?id=228221205
-- TODO: https://steamcommunity.com/sharedfiles/filedetails/?id=304529695
-- TODO: https://steamcommunity.com/sharedfiles/filedetails/?id=305061933


local print = JewUI.wrappedprint(print, "sv_loc_debug_enable", "LotsOfCurrency:")
local reload_str = "Should we reload LotsOfCurrency to refresh installed currency packs? Useful for debugging packs you're working on."
local con_struct = {
  meta = {
    prefix = "loc",
    title = "LotsOfCurrency",
  },
  toolmenus = {
    {
      tab = "Utilities",
      heading = "User",
      uid = "LotsOfCurrency_UserOptions",
      titlebar = "Lots Of Currency",
      prefix = "cl",
      sets = {FCVAR_ARCHIVE},
      contents = {
        {"category", "hud", "HUD", {
          {"bool", "score_hud", "Should we show a hud value?", 1, 0, 1},
        }},
      },
    },
    {
      tab = "Utilities",
      heading = "Admin",
      uid = "LotsOfCurrency_AdminOptions",
      titlebar = "Lots Of Currency",
      prefix = "sv",
      sets = {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED},
      contents = {
        {"category", "general", "General", {
          {"currencyselect", "enabled_currency", "Double-click to enable / disable currency modules.", {"Currency", "Active?"}, function( lst, lineID, linePanel )
            local key = linePanel:GetColumnText( 1 )
            LotsOfCurrency.EnabledDenominations[key] = not LotsOfCurrency.EnabledDenominations[key]

            RunConsoleCommand("sv_loc_toggle_currency", key, JewUI.truthNumber(LotsOfCurrency.EnabledDenominations[key]))
            linePanel:SetColumnText( 2, JewUI.truthString(LotsOfCurrency.EnabledDenominations[key]) )
          end},
          {"float", "value_base_multiplier", "The base value amount to multiply all currency by.", 1, 0.0, nil},
          {"bool",  "spawn_on_player_death", "Should currency spawn when a player dies?", 1, 0, 1},
          {"float", "value_player_death_multiplier", "Multiply the base value amount by this for player deaths.", 1, 0.0, 1.0},
          {"bool",  "spawn_on_npc_death", "Should currency spawn when an NPC dies?", 1, 0, 1},
          {"float", "value_npc_death_multiplier", "Multiply the base value amount by this for npc deaths.", 1, 0.0, 1.0},
          {"bool",  "spawn_on_prop_break", "Should currency spawn when a prop is broken?", 1, 0, 1},
          {"float", "value_prop_break_multiplier", "Multiply the base value amount by this for broken props.", 1, 0.0, 1.0},
          {"bool",  "spawn_on_vehicle_destroyed", "Should currency spawn when a vehicle is destroyed?", 1, 0, 1},
          {"float", "value_vehicle_destroy_multiplier", "Multiply the base value amount by this for destroyed vehicles.", 1, 0.0, 1.0},
          {"float", "value_random_multiplier", "The max range for a random number used for multiplying worth", 1.25},
          {"bool",  "value_force_prime", "Should the value be rounded to the nearest prime to spawn more collectibles?", 1, 0, 1},
          {"bool",  "value_from_money", "Should the value be based on DarkRP money when available?", 1, 0, 1},
          {"button", "reload", reload_str, {"lotsofcurrency_reload"}},
        }},
        {"category", "awards", "Awards", {
          {"float", "award_armor_multiplier", "How much of the currency's value to award as armor?", 1, 0.0, 1.0},
          {"bool",  "limit_armor", "Should we limit awarded armor?", 0, 0, 1},
          {"float", "limit_armor_upper", "Override max amount of armor to award. 0 = default limit", 0, 0.0, nil},
          {"float", "award_health_multiplier", "How much of the currency's value to award as health?", 1, 0.0, 1.0},
          {"bool",  "limit_health", "Should we limit awarded health?", 0, 0, 1},
          {"float", "limit_health_upper", "Override max amount of health to award. 0 = default limit", 0, 0.0, nil},
          {"float", "award_money_multiplier", "How much of the currency's value to award as money?", 1, 0.0, 1.0},
          {"bool",  "limit_money", "Should we limit awarded money?", 0, 0, 1},
          {"float", "limit_money_upper", "Override max amount of money to award. 0 = default limit", 0, 0.0, nil},
        }},
        {"category", "physical_properties", "Physical Properties", {
          {"bool",  "allow_touch", "Should touching allow picking up currency?", 1, 0, 1},
          {"bool",  "allow_use", "Should +use allow picking up currency?", 1, 0, 1},
          {"float", "bounce_count", "How many times should bounce-enabled entities bounce before stopping?", 5, 0, nil},
          {"float", "bounce_force", "How much force should bounce-enabled entities use initially?", 360, 0, nil},
          {"float", "spawn_up_force", "How much force should entities have when spawning?", 5, 0, nil},
          {"float", "spawn_up_variation", "How much force should vary when entities spawn?", 1.25, 1, nil},
          {"float", "spawn_area_range", "How far from the victim should currency spawn?", 10, 0, nil},
          {"float", "despawn_period", "How much time before currency despawns, in seconds? 0 = no despawn", 10, 0, nil},
          {"float", "flicker_ratio", "When should we begin flickering, as a ratio of the duration of despawn_period? 1 = no flicker", 0.6, 0.0, 1.0},
          {"float", "flicker_frequency", "How frequently should we flicker after the flicker_ratio elapses?", 1.618, 0.0, nil},
        }},
        {"category", "debug", "Debug", {
          {"bool", "debug_enable", "Should we be using extra debug prints?", 0, 0, 1},
        }},
      }
    },
  },
  -- {"sleep_period", "How much time before currency stops moving, in seconds?", 7, 0, nil},
}

JewUI.PopulateConVars(con_struct)

LotsOfCurrency = {
  ConVars = con_struct,
  EnabledDenominations = {},
  Denominations = {},
  HooksToKill = {},
}

if CLIENT then
  function LotsOfCurrency.RefreshListView()
    if LotsOfCurrency.ListView then
      LotsOfCurrency.ListView:Clear()

      for k, _ in SortedPairs(LotsOfCurrency.Denominations) do
        LotsOfCurrency.ListView:AddLine( k, JewUI.truthString(LotsOfCurrency.EnabledDenominations[k]) )
      end

      LotsOfCurrency.ListView:GetDataHeight()
      LotsOfCurrency.ListView:SetTall(22 + math.min(LotsOfCurrency.ListView:DataLayout(), 160))
    end
  end
end

if SERVER then
  util.AddNetworkString("loc_sendenableddenoms")

  function LotsOfCurrency.SendEnabledDenoms(ply)
    if not LotsOfCurrency.EnabledDenominations then return end

    net.Start("loc_sendenableddenoms")
    net.WriteUInt(table.Count(LotsOfCurrency.EnabledDenominations), 32)

    for denom, state in pairs(LotsOfCurrency.EnabledDenominations) do
        net.WriteString(denom)
        net.WriteBool(state)
    end

    if not IsValid(ply) then
      net.Broadcast()
    else
      net.Send(ply)
    end
  end

  hook.Add( "PlayerInitialSpawn", "FullLoadSetup", function( ply )
    hook.Add( "SetupMove", ply, function( self, ply2, _, cmd )
      if self == ply2 and not cmd:IsForced() then
        hook.Run( "PlayerFullLoad", self )
        LotsOfCurrency.SendEnabledDenoms(ply2)
        hook.Remove( "SetupMove", self )
      end
    end )
  end )
end
-- support old packs someone might be working on
LotsOfCurrency.HasWorkshopItem = JewUI.HasWorkshopItem
function LotsOfCurrency.KillHooks()
  for i = 1, #LotsOfCurrency.HooksToKill do
    local theHook = LotsOfCurrency.HooksToKill[i]
    hook.Remove(theHook[1], theHook[2])
  end

  if SERVER then
    if (file.Exists( "lots_of_currency_enabled_denoms.txt", "DATA" )) then
      LotsOfCurrency.EnabledDenominations = table.Merge(LotsOfCurrency.EnabledDenominations, util.JSONToTable( file.Read( "lots_of_currency_enabled_denoms.txt", "DATA" )) or {})
    else
      file.Write( "lots_of_currency_enabled_denoms.txt", util.TableToJSON( LotsOfCurrency.EnabledDenominations ) )
    end

    LotsOfCurrency.SendEnabledDenoms()
  end
end

function LotsOfCurrency.GetValue(val)
  val = GetConVar("sv_loc_value_base_multiplier"):GetFloat() * val

  -- @TODO: alternate from max health

  val = val * math.Rand(1, GetConVar("sv_loc_value_random_multiplier"):GetFloat())

  if GetConVar("sv_loc_value_force_prime"):GetBool() then
    val = JewUI.nearest_prime(val)
  end

  --print("about to feed", val)
  return val
end

function LotsOfCurrency.RegisterDenomination(denomName, valueTable, entsToMake, hooksToKill)
  LotsOfCurrency.EnabledDenominations[denomName] = true
  LotsOfCurrency.Denominations[denomName] = valueTable

  for k, v in pairs( entsToMake ) do
    local split_name = string.Replace( k, "_", " " )

    local ENT = {
      Type                = "anim",
      Base                = "lots_of_currency_base",

      PrintName           = split_name:gsub("(%l)(%w*)", function(a,b) return string.upper(a) .. b end),
      Author              = "EntranceJew",
      Category            = "Lots of Currency",
      Spawnable           = DarkRP ~= nil,
      AdminSpawnable      = DarkRP == nil,

      Model               = nil,
      SpriteMaterial	    = nil,
      Worth				        = 1,
      ShouldDespawn       = false,
      ShouldBounce        = false,
      EnergeticBounce     = false,
      EnergeticBounceVel  = 50,
      BounceDecay         = 0.5,
      SpawnNoises		      = nil,
      BounceNoises		    = nil,
      BounceNoisePitch    = 125,
      CollectNoises		    = nil,
      CollectNoisePitch   = 100,
      HullSize            = 16,
      NoSelfCollide       = false,
      NoShadow            = true,
      DoCam3D             = false,
      Unicorn 			      = false,

      DespawnTime         = 0,
      FlickerTime         = 0,
      FlickerFrequency    = 0,
      Bounces             = 0,
      BouncesTotal        = 0,
      BounceForce         = 0,
    }
    ENT = table.Merge(ENT, v)
    if ENT.SpriteColor == nil then
      ENT.SpriteColor = color_white
    end

    scripted_ents.Register( ENT, k )
  end

  hooksToKill = hooksToKill or {}
  for i = 1, #hooksToKill do
    table.insert(LotsOfCurrency.HooksToKill, hooksToKill[i])
  end
end

function LotsOfCurrency.PickRandomDenom()
  local denoms = {}
  for k, v in pairs(LotsOfCurrency.EnabledDenominations or {}) do
    if v and LotsOfCurrency.Denominations[k] ~= nil then
      table.insert(denoms, k)
    end
  end

  if #denoms < 1 then return nil, nil end
  local denomName = denoms[ math.random( #denoms ) ]
  return denomName, LotsOfCurrency.Denominations[denomName]
end

function LotsOfCurrency.SpawnDenom( denom, pos, value )
  -- print(denom)
  local tier = LotsOfCurrency.Denominations[denom]
  pos.z = pos.z + 20

  local totalValue = 0

  for i, v in ipairs( tier.values ) do
    r = math.floor((value - totalValue) / v)
    totalValue = totalValue + (v * r)
    for j = 1, r do
      local chosen_ent = tier.ents[i]
      if type(chosen_ent) == "table" then
        if #chosen_ent == 0 then
          chosen_ent = JewUI.weightedchoice(chosen_ent)
        else
          chosen_ent = chosen_ent[ math.random(1, #chosen_ent) ]
        end
      end
      if tier.spawnfunc then
        tier.spawnfunc( chosen_ent, pos )
      else
        LotsOfCurrency.Spawn3D( chosen_ent, pos )
      end
    end
  end
end

function LotsOfCurrency.Spawn3D( entName, pos )
  if CLIENT then return end
  -- TODO: spawn with random vector angle offset + range
  local sar = GetConVar("sv_loc_spawn_area_range"):GetFloat()
  pos.x = pos.x + math.random( -sar, sar )
  pos.y = pos.y + math.random( -sar, sar )

  --print("spawning a:", entName, ents)
  --PrintTable(ents)
  local currency = ents.Create( entName )

  if ( IsValid( currency ) ) then
    currency:SetPos( pos )
    currency:SetAngles( Angle( math.random( 360 ), math.random( 360 ), math.random( 360 ) ) )
    currency:Spawn()
    local po = currency:GetPhysicsObject()
    po:Wake()
    local mul = (po:GetMass() * GetConVar("sv_loc_bounce_force"):GetFloat())
    local up = GetConVar("sv_loc_spawn_up_force"):GetFloat() * math.Rand(1, GetConVar("sv_loc_spawn_up_variation"):GetFloat())
    force = Vector(math.Rand(-1, 1), math.Rand(-1, 1), up):GetNormalized() * mul
    po:ApplyForceCenter(force)
  end
end

-- hooks
hook.Add("simfphysOnDestroyed", "LotsOfCurrency_simfphysOnDestroyed", function(vehicle, gibs)
  -- vehicle:SetNWInt("LotsOfCurrencyWorth", 0)
  if not GetConVar("sv_loc_spawn_on_vehicle_destroyed"):GetBool() then return end
  local denomName, denomData = LotsOfCurrency.PickRandomDenom()
  if denomName == nil then return end

  local val = vehicle:GetMaxHealth()
  if denomData.vehicleworthfunc then
    val = denomData.vehicleworthfunc(vehicle, gibs)
  end
  val = LotsOfCurrency.GetValue(val * GetConVar("sv_loc_value_vehicle_destroy_multiplier"):GetFloat())

  LotsOfCurrency.SpawnDenom(denomName, vehicle:GetPos(), val)
end)
hook.Add("PropBreak", "LotsOfCurrency_PropBreak", function(attacker, prop)
  -- prop:SetNWInt("LotsOfCurrencyWorth", 0)
  if not GetConVar("sv_loc_spawn_on_prop_break"):GetBool() or not IsValid(prop) or prop == NULL or prop.GetMaxHealth == nil then return end
  local denomName, denomData = LotsOfCurrency.PickRandomDenom()
  if denomName == nil then return end

  local val = prop:GetMaxHealth()
  if denomData.propworthfunc then
    val = denomData.propworthfunc(attacker, prop)
  end
  val = LotsOfCurrency.GetValue(val * GetConVar("sv_loc_value_prop_break_multiplier"):GetFloat())

  LotsOfCurrency.SpawnDenom(denomName, prop:GetPos(), val)
end)
hook.Add("OnNPCKilled", "LotsOfCurrency_NPCKilled", function( victim, attacker, inflictor )
  victim:SetNWInt("LotsOfCurrencyWorth", 0)
  if not GetConVar("sv_loc_spawn_on_npc_death"):GetBool() then return end
  local denomName, denomData = LotsOfCurrency.PickRandomDenom()
  if denomName == nil then return end

  local val = victim:GetMaxHealth()
  if denomData.npcworthfunc then
    val = denomData.npcworthfunc(victim)
  end
  val = LotsOfCurrency.GetValue(val * GetConVar("sv_loc_value_npc_death_multiplier"):GetFloat())

  LotsOfCurrency.SpawnDenom(denomName, victim:GetPos(), val)
end)
hook.Add("DoPlayerDeath", "LotsOfCurrency_PlayerDeath", function( ply, attacker, dmg )
  ply:SetNWInt("LotsOfCurrencyWorth", 0)
  if not GetConVar("sv_loc_spawn_on_player_death"):GetBool() then return end
  local denomName, denomData = LotsOfCurrency.PickRandomDenom()
  if denomName == nil then return end

  local val = ply:GetMaxHealth()
  if DarkRP and GetConVar("sv_loc_value_from_money"):GetBool() and ply.getDarkRPVar and ply.addMoney then
    val = ply:getDarkRPVar("money")
    ply:addMoney(-val)
  end
  ply.LotsOfCurrencyWorth = 0
  if denomData.playerworthfunc then
    val = denomData.playerworthfunc(ply)
  end
  val = LotsOfCurrency.GetValue(val * GetConVar("sv_loc_value_player_death_multiplier"):GetFloat())

  LotsOfCurrency.SpawnDenom(denomName, ply:EyePos(), val)
end)

/*
-- we can't use this because some dumb shit so instead we have to waste everyone's frames
if CLIENT then
  local function format_int(number)
    local _, _, minus, int, fraction = tostring(number):find("([-]?)(%d+)([.]?%d*)")
    -- reverse the int-string and append a comma to all blocks of 3 digits
    int = int:reverse():gsub("(%d%d%d)", "%1,")

    -- reverse the int-string back remove an optional comma and put the 
    -- optional minus and fractional part back
    return minus .. int:reverse():gsub("^,", "") .. fraction
  end

  local enableHud = function()
    print("enabling!")
    hook.Add( "HUDPaint", "LotsOfCurrency_ScoreHUD", function()
      local t = format_int(LocalPlayer():GetNWInt("LotsOfCurrencyWorth", 0))
      surface.SetFont("CloseCaption_Bold")
      local w, h = surface.GetTextSize(t)
      local m = 8
      surface.SetDrawColor( 0, 0, 0, 128 )
      draw.RoundedBox(
        m,
        ScrW() - w - m - m - m - m,
        m,
        w + m + m + m,
        h + m,
        Color( 0, 0, 0, 128 )
      )
      -- surface.DrawRect(
      --   --16,
      --   ScrW() - w - m - m - m - m,
      --   m,
      --   w + m + m + m,
      --   h + m,
      --   Color( 0, 0, 0, 128 )
      -- )
      surface.SetTextPos(
        ScrW() - w - m - m - ( m / 2),
        m + ( m / 2 )
      )
      surface.SetTextColor(255, 241, 116, 128)
      surface.DrawText(t)
    end )
  end
  local disableHud = function()
    print("disabling!")
    hook.Remove("HUDPaint", "LotsOfCurrency_ScoreHUD")
  end
  cvars.AddChangeCallback( "cl_loc_score_hud", function(cv, old, new)
    print("changed!")
    if new == "1" then
      enableHud()
    elseif new == "0" then
      disableHud()
    end
  end, "LotsOfCurrency_ChangeCallback_cl_loc_score_hud")

  if GetConVar("cl_loc_score_hud"):GetBool() then
    enableHud()
  end
end
*/

if CLIENT then
  hook.Add( "HUDPaint", "LotsOfCurrency_ScoreHUD", function()
    if not GetConVar("cl_loc_score_hud"):GetBool() then return end
    local t = string.Comma(LocalPlayer():GetNWInt("LotsOfCurrencyWorth", 0))
    surface.SetFont("CloseCaption_Bold")
    local w, h = surface.GetTextSize(t)
    local m = 8
    surface.SetDrawColor( 0, 0, 0, 128 )
    draw.RoundedBox(
      m,
      ScrW() - w - m - m - m - m,
      m,
      w + m + m + m,
      h + m,
      Color( 0, 0, 0, 128 )
    )
    -- surface.DrawRect(
    --   --16,
    --   ScrW() - w - m - m - m - m,
    --   m,
    --   w + m + m + m,
    --   h + m,
    --   Color( 0, 0, 0, 128 )
    -- )
    surface.SetTextPos(
      ScrW() - w - m - m - ( m / 2),
      m + ( m / 2 )
    )
    surface.SetTextColor(255, 241, 116, 128)
    surface.DrawText(t)
  end )
end

concommand.Add("sv_loc_toggle_currency", function( ply, cmd, args )
  --print(cmd, args)

  local denom = args[1]
  local state = args[2]
  if state == "1" then
    state = true
  elseif state == "0" then
    state = false
  else
    print("Invalid state.")
    return
  end

  if LotsOfCurrency.EnabledDenominations[denom] == nil then
    print("Denomination ", denom, "does not exist.")
    return
  end

  LotsOfCurrency.EnabledDenominations[denom] = state

  if SERVER then
    file.Write( "lots_of_currency_enabled_denoms.txt", util.TableToJSON( LotsOfCurrency.EnabledDenominations ) )
    LotsOfCurrency.SendEnabledDenoms()
  end
end)

local function reloadLotsOfCurrency()
  local files = file.Find( "lots_of_currency/modules/*.lua", "LUA" )
  for _,mod in ipairs(files) do
    if SERVER then
      AddCSLuaFile( "lots_of_currency/modules/" .. mod )
    end
    include( "lots_of_currency/modules/" .. mod )
  end
  LotsOfCurrency.KillHooks()
end

concommand.Add("lotsofcurrency_reload", reloadLotsOfCurrency, nil, reload_str)

hook.Add( "InitPostEntity", "LotsOfCurrency_KillHooks", function()
  LotsOfCurrency.KillHooks()
end )

reloadLotsOfCurrency()