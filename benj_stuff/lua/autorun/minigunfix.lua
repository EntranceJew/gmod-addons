hook.Remove("EntityTakeDamage", "TripleDamageOnMinigunHit")
-- hook.Add("EntityTakeDamage", "TripleDamageOnMinigunHit", function(target, dmgInfo)

--     local attacker = dmgInfo:GetAttacker()
--     if IsValid(attacker) and
--         attacker:IsPlayer() and
--         attacker:GetActiveWeapon() and
--         IsValid(attacker:GetActiveWeapon()) and
--         attacker:GetActiveWeapon():GetClass() == "m9k_minigun" then

--         dmgInfo:ScaleDamage(4)
--     end
-- end)
