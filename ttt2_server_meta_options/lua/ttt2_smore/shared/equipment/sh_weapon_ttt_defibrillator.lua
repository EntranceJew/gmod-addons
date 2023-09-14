-- PREVENT REVIVE
TTT2SMORE.HookAdd("TTT2OnEquipmentAddToSettingsMenu", "equipment_weapon_ttt_defibrillator", function(equipment, parent)
	if equipment.ClassName == "weapon_ttt_defibrillator" then
		local form = TTT2SMORE.ExtendEquipmentMenu(equipment, parent)
		TTT2SMORE.MakeElement(form, "equipment_weapon_ttt_defibrillator_disconnect_refund", "MakeCheckBox")
	end
end)

TTT2SMORE.HookAdd("SMORECreateRoleConVars", "equipment_weapon_ttt_defibrillator_prohibit_revive", function(role)
	TTT2SMORE.MakeCVar(role.abbr .. "_prohibit_revive", "0")
end)

TTT2SMORE.HookAdd("TTT2OnRoleAddToSettingsMenu", "equipment_weapon_ttt_defibrillator_prohibit_revive", function(role, parent)
	local form = TTT2SMORE.ExtendRoleMenu(role, parent, "header_roles_smore_all_role_general")

	TTT2SMORE.MakeRoleElement(form, role, "prohibit_revive", "MakeCheckBox")
end)

TTT2SMORE.HookAdd("TTT2AttemptDefibPlayer", "equipment_weapon_ttt_defibrillator_prohibit_revive", function(owner, rag, defib)
	local ply = CORPSE.GetPlayer(rag)
	if IsValid(ply) and ply:GetSubRoleData() and GetConVar("sv_smore_" .. ply:GetSubRoleData().abbr .. "_prohibit_revive"):GetBool() then
		LANG.Msg(owner, "smore_defi_error_player_role", {role = ply:GetRoleString()}, MSG_MSTACK_WARN)
		return false
	end
end)


-- DISCONNECT REFUND
TTT2SMORE.HookAdd("SMORECreateConVars", "equipment_weapon_ttt_defibrillator", function()
	TTT2SMORE.MakeCVar("equipment_weapon_ttt_defibrillator_disconnect_refund", "1")
end)

TTT2SMORE.HookAdd("TTT2DefibError", "all_role_defib_error", function(typ, defib, owner, rag)
	if typ ~= 8 or not owner:IsShopper() or not GetConVar("sv_smore_equipment_weapon_ttt_defibrillator_disconnect_refund"):GetBool() then return end
	local cost = defib.credits or 1
	rag:Remove()
	defib:Remove()
	owner:AddCredits(cost)
	LANG.Msg(owner, "smore_defi_error_player_disconnect_refund", {cost = cost}, MSG_MSTACK_WARN)
	return false
end)