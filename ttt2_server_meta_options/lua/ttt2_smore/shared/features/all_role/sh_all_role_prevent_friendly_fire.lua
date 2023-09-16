local feat = {}

feat.PreventSameSubRoleDamage = function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if
		target:IsPlayer() and attacker:IsPlayer() and
		target:GetSubRole() == attacker:GetSubRole() and
		GetConVar("sv_smore_" .. attacker:GetSubRoleData().abbr .. "_prevent_same_subrole_damage"):GetBool()
	then
		return true
	end
end
feat.PreventSameTeamDamage = function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if
		target:IsPlayer() and attacker:IsPlayer() and
		target:GetTeam() == attacker:GetTeam() and
		GetConVar("sv_smore_" .. attacker:GetSubRoleData().abbr .. "_prevent_same_team_damage"):GetBool()
	then
		return true
	end
end

TTT2SMORE.HookAdd("TTT2OnRoleAddToSettingsMenu", "all_role_prevent_friendly_fire", function(role, parent)
	local form = TTT2SMORE.ExtendRoleMenu(role, parent, "header_roles_smore_all_role_general")

	TTT2SMORE.MakeRoleElement(form, role, "prevent_same_subrole_damage", "MakeCheckBox")
	TTT2SMORE.MakeRoleElement(form, role, "prevent_same_team_damage", "MakeCheckBox")
end)

TTT2SMORE.HookAdd("SMORECreateRoleConVars", "all_role_prevent_friendly_fire", function(role)
	TTT2SMORE.MakeCVar(role.abbr .. "_prevent_same_subrole_damage", "0")
	TTT2SMORE.MakeCVar(role.abbr .. "_prevent_same_team_damage", "0")
end)

TTT2SMORE.HookAdd("EntityTakeDamage", "all_role_prevent_same_subrole_damage", feat.PreventSameSubRoleDamage)
TTT2SMORE.HookAdd("EntityTakeDamage", "all_role_prevent_same_team_damage", feat.PreventSameTeamDamage)

TTT2SMORE.AddFeature("PreventFriendlyFire", feat)
