AddCSLuaFile()

local cv = DeathCombinedLuggage.ConVars

-- local ucwords = function(str)
  -- str = str:gsub("_+", " ")
  -- return str:gsub("(%a)([%w]*)", function(first, rest) return first:upper() .. rest:lower() end)
-- end
local function handleMenu(panel, data, prefix)
  -- local title = ucwords(data[2])
  local varname = prefix .. data[2]
  local el = nil

  local tstring = "#" .. string.lower(DeathCombinedLuggage.ConVars.meta.title) .. "." .. varname .. ".title"
  local dstring = "#" .. string.lower(DeathCombinedLuggage.ConVars.meta.title) .. "." .. varname .. ".description"
  -- DeathCombinedLuggage.PropText = DeathCombinedLuggage.PropText .. "\n" .. string.lower(DeathCombinedLuggage.ConVars.meta.title) .. "." .. varname .. ".title=" .. title
  -- DeathCombinedLuggage.PropText = DeathCombinedLuggage.PropText .. "\n" .. string.lower(DeathCombinedLuggage.ConVars.meta.title) .. "." .. varname .. ".description=" .. data[3]

  if data[1] == "category" then
    local pan = vgui.Create("DForm")
    pan:SetName(dstring)
    for i = 1, #data[4] do
      local v = data[4][i]
      handleMenu(pan, v, prefix)
    end
    panel:AddItem(pan)
    el = pan
  elseif data[1] == "bool" then
    el = panel:CheckBox( tstring, varname )
  elseif data[1] == "string" then
    el = panel:TextEntry(tstring, varname )
  elseif data[1] == "button" then
    el = vgui.Create( "DButton" )
    el:SetText( tstring )
    -- label:SetTextColor( Color( 0, 0, 0 ) )
    if type( data[4] ) == "function" then
      el.DoClick = data[4]
    else
      el.DoClick = function()
        for k2, v2 in pairs(data[4]) do
          RunConsoleCommand( k2, v2 )
        end
      end
    end
    panel:AddItem(el)
  elseif data[1] == "float" then
    local min = data[5] or 0
    local max = data[6] or data[4]
    if data[6] == nil then
      max = math.pow(max, 1.25)
    end
    el = panel:NumSlider( tstring, varname, min, max )
  end
  if data[1] ~= "category" then
    if el ~= nil then
      local tip = varname
      if data[4] ~= nil and type(data[4]) ~= "table" then
        tip = tip .. "\n" .. language.GetPhrase("#default") .. ": " .. data[4]
      end
      el:SetTooltip(tip)
    end
    panel:ControlHelp(dstring)
  end
end
hook.Add( "PopulateToolMenu", cv.meta.title .. "_CustomMenuSettings", function()
  for tm = 1, #cv.toolmenus do
    local tmenu = cv.toolmenus[tm]
    -- print( tmenu.tab .. "/" .. tmenu.heading .. "/" .. cv.meta.title .. "_" .. tmenu.heading .. "Options" )
    spawnmenu.AddToolMenuOption(
        tmenu.tab,
        tmenu.heading,
        cv.meta.title .. "_" .. tmenu.heading .. "Options",
        tmenu.titlebar, "", "", function( panel )
          for i = 1, #tmenu.contents do
            local c = tmenu.contents[i]
            handleMenu(panel, c, tmenu.prefix .. "_" .. cv.meta.prefix .. "_")
          end
    end)
  end
  -- file.Write( string.lower(cv.meta.title) .. ".txt", DeathCombinedLuggage.PropText )
end)
