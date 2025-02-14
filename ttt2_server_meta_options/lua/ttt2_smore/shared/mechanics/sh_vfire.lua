local feat = {}

-- feat.OldSpawnFire = gameEffects.SpawnFire
feat.SpawnFire = function(pos, scale, life_span, owner, parent)
    if CreateVFire then
        return CreateVFire(nil, pos, vector_up, life_span, owner)
    else
        return feat.OldSpawnFire(pos, scale, life_span, owner, parent)
    end
end

-- feat.OldStartFires = gameEffects.StartFires
feat.StartFires = function(pos, tr, num, lifetime, explode, dmgowner, spread_force, immobile, size, lifetime_variance)
    local flames = {}
    for i = 1, num do
        local ang = Angle(-math.Rand(0, 180), math.Rand(0, 360), math.Rand(0, 360))
        local vstart = pos + tr.HitNormal * 64
        local ttl = lifetime + math.Rand(-lifetime_variance, lifetime_variance)

        if CreateVFireBall then
            flames[#flames + 1] = CreateVFireBall(ttl, size, vstart, ang:Forward() * spread_force, dmgowner)
            continue
        else
            feat.OldStartFires(pos, tr, num, lifetime, explode, dmgowner, spread_force, immobile, size, lifetime_variance)
        end
    end
    return flames
end

TTT2SMORE.HookAdd("TTTBeginRound", "vfire", function()
    if not GetConVar("sv_smore_vfire"):GetBool() then return end

    feat.OldSpawnFire = gameEffects.SpawnFire
    feat.OldStartFires = gameEffects.StartFires
    gameEffects.SpawnFire = feat.SpawnFire
    gameEffects.StartFires = feat.StartFires
end)

TTT2SMORE.HookAdd("SMORECreateConVars", "vfire", function()
    TTT2SMORE.MakeCVar("vfire", "0")
end)

TTT2SMORE.HookAdd("SMOREServerAddonSettings", "vfire", function(parent, general)
    TTT2SMORE.MakeElement(general, "vfire", "MakeCheckBox")
end)

TTT2SMORE.AddFeature("vFire", feat)