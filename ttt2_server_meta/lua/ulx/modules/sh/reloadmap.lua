local CATEGORY_NAME = "Utility"
local function reloadmap( calling_ply )
    RunConsoleCommand("changelevel", game.GetMap())
    ulx.fancyLogAdmin( calling_ply, "#A reloaded the map!" )
end

local reloadmapcmd = ulx.command( CATEGORY_NAME, "ulx reloadmap", reloadmap, "!reloadmap" )
reloadmapcmd:defaultAccess( ULib.ACCESS_ADMIN )
reloadmapcmd:help( "Reloads the current map." )