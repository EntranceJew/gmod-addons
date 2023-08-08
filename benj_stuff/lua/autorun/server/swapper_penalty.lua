local damageTracker = {}


hook.Add("EntityTakeDamage", "SwapperDamageTracker", function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	local amount = dmginfo:GetDamage()

	if IsValid(target) and IsValid(attacker) and target:IsPlayer() and attacker:IsPlayer() and target:GetSubRole() == ROLE_SWAPPER then
		damageTracker[attacker] = (damageTracker[attacker] and damageTracker[attacker] + amount) or amount
	end
end)


hook.Add("PlayerDeath", "SwapperDamageApplier", function(victim, inflictor, attacker)
	if IsValid(victim) and victim:IsPlayer() and victim.GetSubRole and victim:GetSubRole() == ROLE_SWAPPER then
		for player, damage in pairs(damageTracker) do
			if player:Health() <= damage then
				damage = player:Health() - 1
			end

			player:TakeDamage(damage, game.GetWorld(), game.GetWorld())
			roles.JESTER.SpawnJesterConfetti(player)
		end

		damageTracker = {}
	end
end)

hook.Add("TTTBeginRound", "ClearDamageTrackerTable", function()
	damageTracker = {}
end)
