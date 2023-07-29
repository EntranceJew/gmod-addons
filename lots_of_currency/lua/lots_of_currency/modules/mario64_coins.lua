if !LotsOfCurrency.HasWorkshopItem("357286512") then return end

LotsOfCurrency.RegisterDenomination(
  "mario64_coins",
  {
    ents = {"mario64_coin_blue", "mario64_coin_red", "mario64_coin_yellow"},
    values = {5, 2, 1},
    npcworthfunc = function(victim)
      if victim:GetMaxHealth() > 300 then
        return 5
      elseif victim:GetMaxHealth() > 100 then
        return 3
      else
        return 1
      end
    end,
  },
  {
    mario64_coin_blue = {
      PrintName = "Blue Coin",
      SpriteColor = Color(107,107,228),
      Worth = 5,
      SpriteMaterial = "sprites/mario64coin",
      HullSize = 12,
      BounceNoises = {"mario64/bestcoin.wav"},
      CollectNoises = {"mario64/bestcoin.wav"},
      EnergeticBounce = true,
    },
    mario64_coin_red = {
      PrintName = "Red Coin",
      SpriteColor = Color(226,1,0),
      Worth = 2,
      SpriteMaterial = "sprites/mario64coin",
      HullSize = 12,
      BounceNoises = {"mario64/bestcoin.wav"},
      CollectNoises = {"mario64/bestcoin.wav"},
      EnergeticBounce = true,
    },
    mario64_coin_yellow = {
      PrintName = "Yellow Coin",
      SpriteColor = Color(255,255,0),
      Worth = 1,
      SpriteMaterial = "sprites/mario64coin",
      HullSize = 12,
      BounceNoises = {"mario64/bestcoin.wav"},
      CollectNoises = {"mario64/bestcoin.wav"},
      EnergeticBounce = true,
    }
  },
  {
    {"OnNPCKilled","NPC Coin Death"},
    {"PlayerDeath","Player Coin Death"},
  }
)
