local feat = {}

feat.GiveRoleLoadout = function(role, ply, isRoleChange)
	for _, item in ipairs(TTT2SMORE.GetListFromConVar(role.abbr .. "_loadout_append_items")) do
		ply:GiveEquipmentItem(item)
	end
	for _, item in ipairs(TTT2SMORE.GetListFromConVar(role.abbr .. "_loadout_append_weapons")) do
		ply:GiveEquipmentWeapon(item)
	end
end

feat.RemoveRoleLoadout = function(role, ply, isRoleChange)
	for _, item in ipairs(TTT2SMORE.GetListFromConVar(role.abbr .. "_loadout_append_items")) do
		ply:RemoveEquipmentItem(item)
	end
	for _, item in ipairs(TTT2SMORE.GetListFromConVar(role.abbr .. "_loadout_append_weapons")) do
		ply:RemoveEquipmentWeapon(item)
	end
end

feat.DetachRoleLoadout = function(role, ply, isRoleChange)
	for _, item in ipairs(TTT2SMORE.GetListFromConVar(role.abbr .. "_loadout_detach_items")) do
		ply:RemoveEquipmentItem(item)
	end
	for _, item in ipairs(TTT2SMORE.GetListFromConVar(role.abbr .. "_loadout_detach_weapons")) do
		ply:RemoveEquipmentWeapon(item)
	end
end

feat.PatchRole = function(role)
	if role.PreSMOREGiveRoleLoadout == nil then
		role.PreSMOREGiveRoleLoadout = role.GiveRoleLoadout
	-- else
		-- print("overflow", role)
		-- debug.Trace()
	end
	role.GiveRoleLoadout = function(...)
		feat.GiveRoleLoadout(...)
		hook.Run("TTT2SMOREGiveRoleLoadout", ...)
		role.PreSMOREGiveRoleLoadout(...)
		feat.DetachRoleLoadout(...)
		hook.Run("TTT2SMOREDetachRoleLoadout", ...)
	end
	if role.PreSMORERemoveRoleLoadout == nil then
		role.PreSMORERemoveRoleLoadout = role.RemoveRoleLoadout
	end
	role.RemoveRoleLoadout = function(...)
		feat.RemoveRoleLoadout(...)
		hook.Run("TTT2SMORERemoveRoleLoadout", ...)
		role.PreSMORERemoveRoleLoadout(...)
	end
end

TTT2SMORE.HookAdd("SMOREPatchRole", "all_role_loadout_editing", feat.PatchRole)

TTT2SMORE.HookAdd("SMORECreateRoleConVars", "all_role_loadout_editing", function(role)
	TTT2SMORE.MakeCVar(role.abbr .. "_loadout_append_items", "")
	TTT2SMORE.MakeCVar(role.abbr .. "_loadout_append_weapons", "")
	TTT2SMORE.MakeCVar(role.abbr .. "_loadout_detach_items", "")
	TTT2SMORE.MakeCVar(role.abbr .. "_loadout_detach_weapons", "")
end)

TTT2SMORE.HookAdd("TTT2OnRoleAddToSettingsMenu", "all_role_loadout_editing", function(role, parent)
	local form = TTT2SMORE.ExtendRoleMenu(role, parent, "header_roles_smore_all_role_general")

	TTT2SMORE.MakeRoleElement(form, role, "loadout_append_items", "MakeTextEntry")
	TTT2SMORE.MakeRoleElement(form, role, "loadout_append_weapons", "MakeTextEntry")
	TTT2SMORE.MakeRoleElement(form, role, "loadout_detach_items", "MakeTextEntry")
	TTT2SMORE.MakeRoleElement(form, role, "loadout_detach_weapons", "MakeTextEntry")
end)

TTT2SMORE.AddFeature("LoadoutEditing", feat)