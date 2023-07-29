if !LotsOfCurrency.HasWorkshopItem("1234633466") then return end

local spawn_noises = {
  "rupeespawn1.wav",
  "rupeespawn2.wav",
  "rupeespawn3.wav",
  "rupeespawn4.wav",
  "rupeespawn5.wav",
}

LotsOfCurrency.RegisterDenomination(
  "zelda_rupees",
  {
    ents = {"zelda_rupees_gold", "zelda_rupees_orange", "zelda_rupees_silver", "zelda_rupees_purple", "zelda_rupees_red", "zelda_rupees_blue", "zelda_rupees_green"},
    values = {300, 200, 100, 50, 20, 5, 1},
    --[[
    playerworthfunc = function(ply)
      if ( GetConVar( "gmod_functional_rupees_cap" ):GetInt() == 0 or !ply:IsPlayer() ) then
        return ply:GetMaxHealth()
      elseif ( GetConVar( "gmod_functional_rupees_cap" ):GetInt() <= ply:GetMaxHealth() ) then
        return GetConVar( "gmod_functional_rupees_cap" ):GetInt()
      else
        return GetConVar( "gmod_functional_rupees_cap" ):GetInt() - ply:GetMaxHealth()
      end
    end,
    ]]
  },
  {
    zelda_rupees_gold = {
      PrintName = "Orange Rupee",
      Model = "models/gold_rupee/gold_rupee.mdl",
      Worth = 300,
      CollectNoises = {"rupee4.wav"},
      SpawnNoises = spawn_noises,
      BounceNoises = spawn_noises,
    },
    zelda_rupees_orange = {
      PrintName = "Orange Rupee",
      Model = "models/orange_rupee/orange_rupee.mdl",
      Worth = 200,
      CollectNoises = {"rupee3.wav"},
      SpawnNoises = spawn_noises,
      BounceNoises = spawn_noises,
    },
    zelda_rupees_silver = {
      PrintName = "Silver Rupee",
      Model = "models/silver_rupee/silver_rupee.mdl",
      Worth = 100,
      CollectNoises	= {"rupee3.wav"},
      SpawnNoises = spawn_noises,
      BounceNoises = spawn_noises,
    },
    zelda_rupees_purple = {
      PrintName = "Purple Rupee",
      Model = "models/purple_rupee/purple_rupee.mdl",
      Worth = 50,
      CollectNoises = {"rupee2.wav"},
      SpawnNoises = spawn_noises,
      BounceNoises = spawn_noises,
    },
    zelda_rupees_red = {
      PrintName = "Red Rupee",
      Model = "models/red_rupee/red_rupee.mdl",
      Worth = 20,
      CollectNoises = {"rupee2.wav"},
      SpawnNoises = spawn_noises,
      BounceNoises = spawn_noises,
    },
    zelda_rupees_blue = {
      PrintName = "Blue Rupee",
      Model = "models/blue_rupee/blue_rupee.mdl",
      Worth = 5,
      CollectNoises = {"rupee2.wav"},
      SpawnNoises = spawn_noises,
      BounceNoises = spawn_noises,
    },
    zelda_rupees_green = {
      PrintName = "Green Rupee",
      Model = "models/green_rupee/green_rupee.mdl",
      Worth = 1,
      CollectNoises = {"rupee1.wav"},
      SpawnNoises = spawn_noises,
      BounceNoises = spawn_noises,
    },
  },
  {
    {"OnNPCKilled", "FunctionalRupeesNPCDeath"},
    {"DoPlayerDeath", "FunctionalRupeesPlayerDeath"},
  }
)