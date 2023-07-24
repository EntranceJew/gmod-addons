if not SERVER then return end

hook.Add( "Initialize", "PropSpecNoBlueBalls_Initialize", function()
    if GAMEMODE_NAME == "terrortown" and SERVER then
        local mapvote_start = MapVote.Start

        MapVote.Start = function(...)
            -- print("EJEW: mapvote handler called <<<")
            timer.Stop("wait2prep")
            timer.Stop("prep2begin")
            timer.Stop("end2prep")
            timer.Stop("winchecker")
            mapvote_start(...)
        end
    end
end)