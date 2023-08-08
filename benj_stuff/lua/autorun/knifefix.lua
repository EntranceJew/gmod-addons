
local allowedSteamIDs = {
    ["STEAM_0:1:46787806"] = true,
    ["STEAM_0:1:112491145"] = true
}


hook.Add("AllowPlayerPickup", "FixTTT2KnifeIssue", function(ply, ent)

    if not allowedSteamIDs[ply:SteamID()] then
      	print(tostring(ply:SteamID()))
        return
    end

    if ent:GetClass() == "weapon_ttt_knife" then
        -- Pick up the knife for the player even if the server doesn't allow it
        ply:Give("weapon_ttt_knife")
        -- Remove the entity from the world
        ent:Remove()
        -- Return false to prevent the server from executing the default behavior
        return false
    end
    if ent:GetClass() == "weapon_indentiy_disguiser_name" then
        -- Pick up the knife for the player even if the server doesn't allow it
        ply:Give("weapon_indentiy_disguiser_name")
        -- Remove the entity from the world
        ent:Remove()
        -- Return false to prevent the server from executing the default behavior
        return false
    end
end)


