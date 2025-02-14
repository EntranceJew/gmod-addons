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
		local base = weapons.GetStored(wep.Base)
		wep.ViewModel = "models/weapons/c_bugbait.mdl"
		wep.WorldModel = "models/items/combine_rifle_ammo01.mdl"
		-- wep:SetHoldType("pistol")
		wep.HoldType = "grenade"
		wep.ViewModelFOV = 70
		wep.ViewModelFlip = false

		wep.UseHands = true
		wep.ShowDefaultViewModel = false
		wep.ShowDefaultWorldModel = false

		wep.DrawWorldModel = base.DrawWorldModel
		wep.InitializeCustomModels = function(self)
			self:AddCustomViewModel("vmodel", {
				type = "Model",
				model = self.WorldModel,
				bone = "ValveBiped.Bip01_R_Finger2",
				rel = "",
				pos = Vector(1.5, 2.5, 2.5),
				angle = Angle(180, 70, 0),
				size = Vector(0.55, 0.55, 0.55),
				color = Color(255, 255, 255, 255),
				surpresslightning = false,
				material = "",
				skin = 0,
				bodygroup = {},
			})

			self:AddCustomWorldModel("wmodel", {
				type = "Model",
				model = self.WorldModel,
				bone = "ValveBiped.Bip01_R_Hand",
				rel = "",
				pos = Vector(3.2, 2.5, 2.7),
				angle = Angle(180, -100, 0),
				size = Vector(0.65, 0.65, 0.65),
				color = Color(255, 255, 255, 255),
				surpresslightning = false,
				material = "",
				skin = 0,
				bodygroup = {},
			})
		end
	end
end)