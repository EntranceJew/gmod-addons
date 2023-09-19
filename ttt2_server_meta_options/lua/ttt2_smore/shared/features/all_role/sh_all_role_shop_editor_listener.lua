local feat = {}

feat.ShopEditorBeacon = function(ply, rd, equip, cb)
	for _, shopper in pairs(roles.GetShopRoles()) do
		if table.HasValue( TTT2SMORE.GetListFromConVar(shopper.abbr .. "_shop_editor_listening_roles"), rd.name ) then
			if not GetConVar("sv_smore_" .. shopper.abbr .. "_shop_editor_listening_enabled"):GetBool() then continue end
			cb(ply, shopper, equip)
		end
	end
end

feat.AddToShopEditor = function(ply, rd, equip)
	feat.ShopEditorBeacon(ply, rd, equip, ShopEditor.AddToShopEditor)
end
feat.RemoveFromShopEditor = function(ply, rd, equip)
	feat.ShopEditorBeacon(ply, rd, equip, ShopEditor.RemoveFromShopEditor)
end

feat.PatchShopEditor = function()
	if ShopEditor.PreSMOREAddToShopEditor == nil then
		ShopEditor.PreSMOREAddToShopEditor = ShopEditor.AddToShopEditor
	end
	ShopEditor.AddToShopEditor = function(...)
		ShopEditor.PreSMOREAddToShopEditor(...)
		hook.Run("TTT2SMOREAddToShopEditor", ...)
		feat.AddToShopEditor(...)
	end
	if ShopEditor.PreSMORERemoveFromShopEditor == nil then
		ShopEditor.PreSMORERemoveFromShopEditor = ShopEditor.RemoveFromShopEditor
	end
	ShopEditor.RemoveFromShopEditor = function(...)
		ShopEditor.PreSMORERemoveFromShopEditor(...)
		hook.Run("TTT2SMORERemoveFromShopEditor", ...)
		feat.RemoveFromShopEditor(...)
	end
end

TTT2SMORE.HookAdd("SMORECreateRoleConVars", "shop_editor_listener", function(role)
	TTT2SMORE.MakeCVar(role.abbr .. "_shop_editor_listening_enabled", "0")
	TTT2SMORE.MakeCVar(role.abbr .. "_shop_editor_listening_roles", "")
end)

TTT2SMORE.HookAdd("TTT2OnRoleAddToSettingsMenu", "shop_editor_listener", function(role, parent)
	local all_shopping_role_names = {}
	local all_shoppers = roles.GetShopRoles()
	for _, shop_role in pairs(all_shoppers) do
		table.insert(all_shopping_role_names, shop_role.name)
	end
	local all_shoppers_str = table.concat(all_shopping_role_names, ", ")
	local form = TTT2SMORE.ExtendRoleMenu(role, parent, "header_roles_smore_all_role_general")

	TTT2SMORE.MakeRoleElement(form, role, "shop_editor_listening_enabled", "MakeCheckBox")
	TTT2SMORE.MakeRoleElement(form, role, "shop_editor_listening_roles", "MakeTextEntry", { help_params = {roles = all_shoppers_str}})
end)

TTT2SMORE.HookAdd("SMOREPatchCoreTTT2", "shop_editor_listener", feat.PatchShopEditor)

TTT2SMORE.AddFeature("ShopEditorListener", feat)