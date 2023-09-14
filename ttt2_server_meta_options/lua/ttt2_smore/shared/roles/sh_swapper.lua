TTT2SMORE.RegisterRoundData("SwapperDamageTracker", {})

TTT2SMORE.HookAdd("SMORECreateConVars", "swa_create_con_vars", function(role)
	TTT2SMORE.MakeCVar("swa_shared_damage_enabled", "0")
	TTT2SMORE.MakeCVar("swa_shared_damage_multiplier", "1")
	TTT2SMORE.MakeCVar("swa_shared_damage_survive_health", "1")
end)

TTT2SMORE.HookAdd("TTT2OnRoleAddToSettingsMenu", "swa", function(role, parent)
	if role.abbr == "swa" then
		local rform = TTT2SMORE.ExtendRoleMenu(role, parent, "header_roles_smore_swa_general")
		TTT2SMORE.MakeElement(rform, "swa_shared_damage_enabled", "MakeCheckBox")
		TTT2SMORE.MakeElement(rform, "swa_shared_damage_multiplier", "MakeSlider", {max = 5, decimal = 1})
		TTT2SMORE.MakeElement(rform, "swa_shared_damage_survive_health", "MakeSlider")
	end
end)

TTT2SMORE.HookAdd("EntityTakeDamage", "swa_damage_tracker_penalty", function(target, dmginfo)
	--[[
		_swa_shared_damage_enabled
		_swa_shared_damage_multiplier
	]]
	if not GetConVar("sv_smore_swa_shared_damage_enabled"):GetBool() then return end
	local attacker = dmginfo:GetAttacker()
	if
		target:IsPlayer() and attacker:IsPlayer() and
		target:GetSubRole() == ROLE_SWAPPER
	then
		local t_uid, a_uid = target:UserID(), attacker:UserID()
		local amount = math.Round(dmginfo:GetDamage() * GetConVar("sv_smore_swa_shared_damage_multiplier"):GetFloat())
		if not TTT2SMORE.RDATA.SwapperDamageTracker then
			TTT2SMORE.RDATA.SwapperDamageTracker = {}
		end
		if not TTT2SMORE.RDATA.SwapperDamageTracker[t_uid] then
			TTT2SMORE.RDATA.SwapperDamageTracker[t_uid] = {}
		end
		if not TTT2SMORE.RDATA.SwapperDamageTracker[t_uid][a_uid] then
			TTT2SMORE.RDATA.SwapperDamageTracker[t_uid][a_uid] = 0
		end

		local damage = TTT2SMORE.RDATA.SwapperDamageTracker[t_uid][a_uid] + amount
		TTT2SMORE.RDATA.SwapperDamageTracker[t_uid][a_uid] = damage
	end
end)

TTT2SMORE.HookAdd("PlayerDeath", "swa_apply_tracked_damage", function(victim, inflictor, attacker)
	--[[
		_swa_shared_damage_survive_health
	]]
	local is_swapper_death = victim:GetSubRole() == ROLE_SWAPPER
	if
		IsValid(victim)	and victim:IsPlayer() and is_swapper_death
	then
		local v_uid = victim:UserID()
		for uid, damage in pairs((TTT2SMORE.RDATA.SwapperDamageTracker and TTT2SMORE.RDATA.SwapperDamageTracker[v_uid]) or {}) do
			if damage <= 0 then continue end
			local ply = Player( uid )

			local remaining_health = math.max(ply:Health() - damage, GetConVar("sv_smore_swa_shared_damage_survive_health"):GetFloat())
			local real_damage = ply:Health() - remaining_health
			ply:TakeDamage(real_damage, ply, game.GetWorld())
			roles.JESTER.SpawnJesterConfetti(ply)
		end
		TTT2SMORE.RDATA.SwapperDamageTracker[v_uid] = {}
	end
end)
