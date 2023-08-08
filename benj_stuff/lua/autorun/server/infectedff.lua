hook.Add("EntityTakeDamage", "TTT2_InfectedFriendlyFire", function(target, dmginfo)
	return target:IsPlayer() and
		dmginfo:GetAttacker():IsPlayer() and
		target:GetSubRole() == ROLE_INFECTED and
		dmginfo:GetAttacker():GetSubRole() == ROLE_INFECTED
end)
