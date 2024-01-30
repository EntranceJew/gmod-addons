TTT2SMORE.HookAdd("SMORECreateConVars", "equipment_weapon_ttt_force_shield", function(role)
	TTT2SMORE.MakeCVar("equipment_weapon_ttt_force_shield_setmodel", "1")
end)

TTT2SMORE.HookAdd("TTT2OnEquipmentAddToSettingsMenu", "equipment_weapon_ttt_force_shield", function(equipment, parent)
	if equipment.ClassName == "weapon_ttt_force_shield" then
		local form = TTT2SMORE.ExtendEquipmentMenu(equipment, parent)
		TTT2SMORE.MakeElement(form, "equipment_weapon_ttt_force_shield_setmodel", "MakeCheckBox")
	end
end)

TTT2SMORE.HookAdd("SMOREPatchCoreTTT2", "equipment_weapon_ttt_force_shield", function()
	local wep = weapons.GetStored("weapon_ttt_force_shield")
	if wep then
		wep.WorldModel = "models/items/combine_rifle_ammo01.mdl"
	end
end)