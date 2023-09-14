local function stop_sound_all(calling_ply)
    for _, ply in ipairs(player.GetAll()) do
        ply:ConCommand("stopsound")
    end

    ulx.fancyLogAdmin(calling_ply, "#A ran stopsound on all clients.")
end
local stopsoundallcmd = ulx.command( "Utility", "ulx stopsoundall", stop_sound_all, "!stopsoundall" )
stopsoundallcmd:defaultAccess( ULib.ACCESS_ADMIN )
stopsoundallcmd:help( "Stops the sound on all clients." )