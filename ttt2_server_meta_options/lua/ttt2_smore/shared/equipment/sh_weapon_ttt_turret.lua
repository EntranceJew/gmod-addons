TTT2SMORE.HookAdd("SMORECreateConVars", "equipment_weapon_ttt_turret", function(role)
	TTT2SMORE.MakeCVar("equipment_weapon_ttt_turret_weight", "1")
end)

TTT2SMORE.HookAdd("TTT2OnEquipmentAddToSettingsMenu", "equipment_weapon_ttt_turret", function(equipment, parent)
	if equipment.ClassName == "weapon_ttt_turret" then
		local form = TTT2SMORE.ExtendEquipmentMenu(equipment, parent)
		TTT2SMORE.MakeElement(form, "equipment_weapon_ttt_turret_weight", "MakeSlider", {min = 0, max = 1, decimal = 2})
	end
end)

if SERVER then
TTT2SMORE.HookAdd( "OnEntityCreated", "weapon_ttt_turret_weight", function( ent )
	timer.Simple(0.5, function()
		if ( IsValid(ent) and ent:GetClass() == "npc_turret_floor" ) then
			local po = ent:GetPhysicsObject()
			po:SetMass(po:GetMass() * GetConVar("sv_smore_equipment_weapon_ttt_turret_weight"):GetFloat())
		end
	end)
end )
end