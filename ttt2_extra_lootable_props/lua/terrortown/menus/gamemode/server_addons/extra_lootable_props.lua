CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "extra_lootable_props_addon_info"

function CLGAMEMODESUBMENU:Populate(parent)
	-- possession:MakeHelp({
	--     label = "help_ttt2_sv_psng_transparent_render_mode"
	-- })

	local general = vgui.CreateTTT2Form(parent, "extra_lootable_props_settings_general")

	general:MakeHelp({
		label = "help_ttt2_sv_elp_enabled",
	})
	general:MakeCheckBox({
	    label = "label_ttt2_sv_elp_enabled",
	    serverConvar = "sv_elp_enabled"
	})

	general:MakeHelp({
		label = "help_ttt2_sv_elp_only_appropriate_props",
	})
	general:MakeCheckBox({
	    label = "label_ttt2_sv_elp_only_appropriate_props",
	    serverConvar = "sv_elp_only_appropriate_props"
	})

	general:MakeHelp({
		label = "help_ttt2_sv_elp_prop_name_matches",
	})
	general:MakeTextEntry({
		label = "label_ttt2_sv_elp_prop_name_matches",
		serverConvar = "sv_elp_prop_name_matches",
		-- OnChange = function(...) print("g.mte.oc:", ...) end,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_elp_max_items_per_prop",
	})
	general:MakeSlider({
		label = "label_ttt2_sv_elp_max_items_per_prop",
		serverConvar = "sv_elp_max_items_per_prop",
		min = 0,
		max = 16,
		decimal = 0,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_elp_drop_chance",
	})
	general:MakeSlider({
		label = "label_ttt2_sv_elp_drop_chance",
		serverConvar = "sv_elp_drop_chance",
		min = 0,
		max = 100,
		decimal = 0,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_elp_weapon_drop_chance",
	})
	general:MakeSlider({
		label = "label_ttt2_sv_elp_weapon_drop_chance",
		serverConvar = "sv_elp_weapon_drop_chance",
		min = 0,
		max = 100,
		decimal = 0,
	})
end