if !LotsOfCurrency.HasWorkshopItem("2297524647") then return end

LotsOfCurrency.RegisterDenomination(
  "lego_studs",
  {
    ents = {"lego_studs_purple", "lego_studs_blue", "lego_studs_gold", "lego_studs_silver"},
    values = {10000, 1000, 100, 10},
    playerworthfunc = function(ply)
      if !ply.studWorth then ply.studWorth = 0 end
      local worth = ply.studWorth
      ply.studWorth = 0
      return ply:GetMaxHealth() + worth
    end,
  },
  {
    lego_studs_purple = {
      PrintName = "Purple Stud",
      SpriteMaterial = "sprites/lego_studs/purple_stud",
      Worth = 10000,
      BounceNoises = {"legostud/fall.wav"},
      CollectNoises = {"legostud/pickup.wav"},
      CollectNoisePitch = 125,
      ShouldBounce = true,
    },
    lego_studs_blue = {
      PrintName = "Blue Stud",
      SpriteMaterial = "sprites/lego_studs/blue_stud",
      Worth = 1000,
      BounceNoises = {"legostud/fall.wav"},
      CollectNoises = {"legostud/pickup.wav"},
      ShouldBounce = true,
    },
    lego_studs_gold = {
      PrintName = "Gold Stud",
      SpriteMaterial = "sprites/lego_studs/gold_stud",
      Worth = 100,
      BounceNoises = {"legostud/fall.wav"},
      CollectNoises = {"legostud/silver_pickup.wav"},
      ShouldBounce = true,
    },
    lego_studs_silver = {
      PrintName = "Silver Stud",
      SpriteMaterial = "sprites/lego_studs/silver_stud",
      Worth = 10,
      BounceNoises = {"legostud/fall.wav"},
      CollectNoises = {"legostud/silver_pickup.wav"},
      ShouldBounce = true,
    },
  },
  {
    -- lego studs uses very awful menu names 
    {"AddToolMenuCategories", "CustomCategory"},
    {"PopulateToolMenu", "CustomMenuSettings"},
    {"PlayerDeath", "LegoCoinPlayer"},
    {"OnNPCKilled", "LegoCoinNPC"},
    {"PropBreak", "LegoCoinProp"},
  }
)
