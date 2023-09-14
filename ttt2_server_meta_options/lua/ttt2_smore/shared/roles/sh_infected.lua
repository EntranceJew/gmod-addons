-- @WARNING: THIS DEPENDS ON FEATURE: ALL ROLE LOADOUT EDITING

TTT2SMORE.HookAdd("TTT2SMOREGiveRoleLoadout", "inf_zombie_loadout_editing", function(role, ply)
	-- print("infected loadout")
	if role.abbr ~= "inf" or INFECTEDS[ply] then return end
	for _, item in ipairs(TTT2SMORE.GetListFromConVar("inf_zombie_loadout_append_items")) do
		-- print("infected item:", ply, item)
		ply:GiveEquipmentItem(item)
	end
	for _, item in ipairs(TTT2SMORE.GetListFromConVar("inf_zombie_loadout_append_weapons")) do
		ply:GiveEquipmentWeapon(item)
	end
end)

TTT2SMORE.HookAdd("TTT2SMOREDetachRoleLoadout", "inf_zombie_loadout_editing", function(role, ply)
	if role.abbr ~= "inf" or INFECTEDS[ply] then return end
	for _, item in ipairs(TTT2SMORE.GetListFromConVar("inf_zombie_loadout_detach_items")) do
		ply:RemoveEquipmentItem(item)
	end
	for _, item in ipairs(TTT2SMORE.GetListFromConVar("inf_zombie_loadout_detach_weapons")) do
		ply:RemoveEquipmentWeapon(item)
	end
end)

TTT2SMORE.HookAdd("TTT2SMORERemoveRoleLoadout", "inf_zombie_loadout_editing", function(role, ply)
	if role.abbr ~= "inf" or INFECTEDS[ply] then return end
	for _, item in ipairs(TTT2SMORE.GetListFromConVar("inf_zombie_loadout_append_items")) do
		ply:RemoveEquipmentItem(item)
	end
	for _, item in ipairs(TTT2SMORE.GetListFromConVar("inf_zombie_loadout_append_weapons")) do
		ply:RemoveEquipmentWeapon(item)
	end
end)

TTT2SMORE.HookAdd("SMORECreateConVars", "inf_zombie_loadout_editing", function()
	TTT2SMORE.MakeCVar("inf_zombie_loadout_append_items", "")
	TTT2SMORE.MakeCVar("inf_zombie_loadout_append_weapons", "")
	TTT2SMORE.MakeCVar("inf_zombie_loadout_detach_items", "")
	TTT2SMORE.MakeCVar("inf_zombie_loadout_detach_weapons", "")
end)

TTT2SMORE.HookAdd("TTT2OnRoleAddToSettingsMenu", "inf_zombie_loadout_editing", function(role, parent)
	if role.abbr == "inf" then
		local form = TTT2SMORE.ExtendRoleMenu(role, parent, "header_roles_smore_inf_general")
		TTT2SMORE.MakeElement(form, "inf_zombie_loadout_append_items", "MakeTextEntry")
		TTT2SMORE.MakeElement(form, "inf_zombie_loadout_append_weapons", "MakeTextEntry")
		TTT2SMORE.MakeElement(form, "inf_zombie_loadout_detach_items", "MakeTextEntry")
		TTT2SMORE.MakeElement(form, "inf_zombie_loadout_detach_weapons", "MakeTextEntry")
	end
end)