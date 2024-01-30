local feat = {}

feat.SpawnTable = {
	ammo = {
	},
	weapon = {
		["neo_ghostspawnpoint"] = WEAPON_TYPE_SPECIAL,
		["neo_ghost_retrieval_point"] = WEAPON_TYPE_SPECIAL,
	},
	player = {
		["info_player_attacker"] = PLAYER_TYPE_RANDOM,
		["info_player_defender"] = PLAYER_TYPE_RANDOM,
	}
}

feat.RegisterAmmo = function(spawns)
	if not GetConVar("sv_smore_tie_breaker_enable"):GetBool() then return end
	for k, v in pairs(feat.SpawnTable.ammo) do
		spawns[k] = v
	end
end

feat.RegisterWeapon = function(spawns)
	if not GetConVar("sv_smore_tie_breaker_enable"):GetBool() then return end
	for k, v in pairs(feat.SpawnTable.weapon) do
		spawns[k] = v
	end
end

feat.RegisterPlayer = function(spawns)
	if not GetConVar("sv_smore_tie_breaker_enable"):GetBool() then return end
	for k, v in pairs(feat.SpawnTable.player) do
		spawns[k] = v
	end
end

feat.DummyMapEnts = function()
	if not GetConVar("sv_smore_tie_breaker_enable"):GetBool() then return end

	for cat, data in pairs(test_spawns) do
		for ent_name, ent_type in pairs(data) do
			local stored = scripted_ents.GetStored(ent_name)
			if stored == nil then
				scriped_ents.Register({
					Type = "point",
					Base = "base_point",
				}, ent_name)
			end
		end
	end
end


TTT2SMORE.HookAdd("SMORECreateConVars", "map_compat_neotokyo", function()
	TTT2SMORE.MakeCVar("map_compat_neotokyo_enable", "0")
end)

TTT2SMORE.HookAdd("SMOREServerAddonSettings", "map_compat_neotokyo", function(parent, general)
	TTT2SMORE.MakeElement(general, "map_compat_neotokyo_enable", "MakeCheckBox")
end)

TTT2SMORE.HookAdd("Initialize", "map_compat_neotokyo", feat.DummyMapEnts)
TTT2SMORE.HookAdd("TTT2MapRegisterAmmoSpawns", "map_compat_neotokyo", feat.RegisterAmmo)
TTT2SMORE.HookAdd("TTT2MapRegisterWeaponSpawns", "map_compat_neotokyo", feat.RegisterWeapon)
TTT2SMORE.HookAdd("TTT2MapRegisterPlayerSpawns", "map_compat_neotokyo", feat.RegisterPlayer)

TTT2SMORE.AddFeature("MapCompatNeotokyo", feat)
