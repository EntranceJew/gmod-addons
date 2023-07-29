AddCSLuaFile()
local JewUI = include("lots_of_currency/jewui.lua")

net.Receive("loc_sendenableddenoms", function(len, ply)
  LotsOfCurrency.EnabledDenominations = {}

  local count = net.ReadUInt(32)

  for i = 1, count do
      local denom = net.ReadString()
      local state = net.ReadBool()
      LotsOfCurrency.EnabledDenominations[denom] = state
  end

  LotsOfCurrency.RefreshListView()
end)

JewUI.PopulateToolMenus(LotsOfCurrency.ConVars)