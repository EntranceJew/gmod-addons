--Turns out this was pointless cause you can just press F2 lmao
concommand.Add("mutespec", function()
    if LocalPlayer():IsSpec() then
        local specs = player.GetAll()
        for i, ply in ipairs(specs) do
            if ply:IsSpec() and ply ~= LocalPlayer() then
                ply:SetMuted(true)
            end
        end

        print("All spectator voices have been muted.")
    else
        print("You must be a spectator to use this command.")
    end
end)


concommand.Add("unmutespec", function()
    if LocalPlayer():IsSpec() then
        local specs = player.GetAll()
        for i, ply in ipairs(specs) do
            if ply:IsSpec() and ply ~= LocalPlayer() then
                ply:SetMuted(false)
            end
        end
        print("All spectator voices have been unmuted.")
    else
        print("You must be a spectator to use this command.")
    end
end)


local entitiesByType = {}
local entities = ents.GetAll()

for _, ent in pairs(entities) do
    local entType = ent:GetClass()
    entitiesByType[entType] = entitiesByType[entType] or {}
    table.insert(entitiesByType[entType], ent)
end

for entType, entsOfType in pairs(entitiesByType) do
    print(entType .. ":")
    for _, ent in pairs(entsOfType) do
        local pos = ent:GetPos()
        print("  (" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")")
    end
end
