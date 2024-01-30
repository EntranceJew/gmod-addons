-- @WARNING: THIS DEPENDS ON FEATURE: ALL ROLE LOADOUT EDITING

TTT2SMORE.HookAdd("TTT2SMOREGiveRoleLoadout", "inf_zombie_loadout_editing", function(role, ply)
	if role.abbr ~= "inf" or INFECTEDS[ply] then return end
	for _, item in ipairs(TTT2SMORE.GetListFromConVar("inf_zombie_loadout_append_items")) do
		ply:GiveEquipmentItem(item)
	end
	for _, item in ipairs(TTT2SMORE.GetListFromConVar("inf_zombie_loadout_append_weapons")) do
		ply:GiveEquipmentWeapon(item)
	end
	-- set color
	ply:SetPlayerColor( TTT2SMORE.GetColorFromConVar("inf_zombie_color"):ToVector() )
end)

--[[
hook.Add("TTTPlayerSetColor", function(ply)
	print("=> SetColor ???")
	if SERVER
		and ply:GetSubRole() == ROLE_INFECTED
		and not INFECTEDS[ply]
		and GetConVar("sv_smore_inf_zombie_prevent_set_model"):GetBool()
	then
		print("=> SetColor !!!")
		ply:SetSubRoleModel(GAMEMODE.playermodel)
	end
end)

hook.Add("TTT2UpdateSubrole", "gumpo", function(ply, oldSubrole, newSubrole)
	print("EntranceJew Questioning")
	if SERVER
		and newSubrole == ROLE_INFECTED
		and not INFECTEDS[ply]
		and GetConVar("sv_smore_inf_zombie_prevent_set_model"):GetBool()
	then
		print("EntranceJew Testerin!!g!")
		ply:SetSubRoleModel(GAMEMODE.playermodel)
	end
end)
]]

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
	-- TTT2SMORE.MakeCVar("inf_zombie_prevent_set_model", "0")
	TTT2SMORE.MakeCVar("inf_zombie_color", "255 255 255 255")
end)

TTT2SMORE.HookAdd("TTT2OnRoleAddToSettingsMenu", "inf_zombie_loadout_editing", function(role, parent)
	if role.abbr == "inf" then
		local form = TTT2SMORE.ExtendRoleMenu(role, parent, "header_roles_smore_inf_general")
		TTT2SMORE.MakeElement(form, "inf_zombie_loadout_append_items", "MakeTextEntry")
		TTT2SMORE.MakeElement(form, "inf_zombie_loadout_append_weapons", "MakeTextEntry")
		TTT2SMORE.MakeElement(form, "inf_zombie_loadout_detach_items", "MakeTextEntry")
		TTT2SMORE.MakeElement(form, "inf_zombie_loadout_detach_weapons", "MakeTextEntry")
		-- TTT2SMORE.MakeElement(form, "inf_zombie_prevent_set_model", "MakeCheckBox")
		TTT2SMORE.MakeElement(form, "inf_zombie_color", "MakeColorMixer", {
			initial = TTT2SMORE.GetColorFromConVar("inf_zombie_color"),
			OnChange = function(_, color)
				cvars.ChangeServerConVar("sv_smore_inf_zombie_color", TTT2SMORE.GetStringFromColor(color))
			end,
		})
	end
end)