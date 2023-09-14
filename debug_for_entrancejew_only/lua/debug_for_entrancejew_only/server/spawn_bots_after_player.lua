hook.Add( "PlayerInitialSpawn", "ej_debug_spawn_bots_after_player", function()
    hook.Remove( "PlayerInitialSpawn", "ej_debug_spawn_bots_after_player" )
    local delay = 0.4
    for i = player.GetCount() + 1, game.MaxPlayers() do
        timer.Simple(i * delay, function()
            RunConsoleCommand("ttt_bot_add")
        end)
    end
end )