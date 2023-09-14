local feat = {}

if SERVER then
	feat.GivePlayerExtraAmmo = function(ply, alive_count)
		if ply:GetActiveWeapon() ~= NULL then
			local wep = ply:GetActiveWeapon()
			local ammoType = wep:GetPrimaryAmmoType()
			local clipSize = wep:GetMaxClip1()
			local extraAmmo = clipSize * GetConVar("sv_smore_round_start_ammo_bonus"):GetFloat()

			ply:GiveAmmo(extraAmmo, ammoType, true)
		end
	end
end

TTT2SMORE.HookAdd("SMORECreateConVars", "extra_ammo", function()
	TTT2SMORE.MakeCVar("round_start_ammo_bonus", "0")
end)

TTT2SMORE.HookAdd("SMOREServerAddonSettings", "extra_ammo", function(parent, general)
	TTT2SMORE.MakeElement(general, "round_start_ammo_bonus", "MakeSlider", {max = 3, decimal = 1})
end)

if SERVER then
	TTT2SMORE.HookAdd("SMORETTTBeginRoundLivingPlayer", "extra_ammo", feat.GivePlayerExtraAmmo)
end

TTT2SMORE.AddFeature("ExtraAmmo", feat)
