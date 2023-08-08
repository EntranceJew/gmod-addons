hook.Add( "PlayerInitialSpawn", "ej_debug_spawn_bots_after_player", function()
    hook.Remove( "PlayerInitialSpawn", "ej_debug_spawn_bots_after_player" )
    for i = player.GetCount()+1, game.MaxPlayers() do
        RunConsoleCommand("bot")
    end
end )