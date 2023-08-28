CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "server_meta_options_addon_info"

function CLGAMEMODESUBMENU:Populate(parent)
	-- possession:MakeHelp({
	--     label = "help_ttt2_sv_psng_transparent_render_mode"
	-- })

	local general = vgui.CreateTTT2Form(parent, "server_meta_options_settings_general")

	general:MakeHelp({
		label = "help_ttt2_sv_smo_enabled",
	})
	general:MakeCheckBox({
	    label = "label_ttt2_sv_smo_enabled",
	    serverConvar = "sv_smo_enabled"
	})

	general:MakeHelp({
		label = "help_ttt2_sv_smo_only_appropriate_props",
	})
	general:MakeCheckBox({
	    label = "label_ttt2_sv_smo_only_appropriate_props",
	    serverConvar = "sv_smo_only_appropriate_props"
	})

	general:MakeHelp({
		label = "help_ttt2_sv_smo_prop_name_matches",
	})
	general:MakeTextEntry({
		label = "label_ttt2_sv_smo_prop_name_matches",
		serverConvar = "sv_smo_prop_name_matches",
		-- OnChange = function(...) print("g.mte.oc:", ...) end,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_smo_max_items_per_prop",
	})
	general:MakeSlider({
		label = "label_ttt2_sv_smo_max_items_per_prop",
		serverConvar = "sv_smo_max_items_per_prop",
		min = 0,
		max = 16,
		decimal = 0,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_smo_drop_chance",
	})
	general:MakeSlider({
		label = "label_ttt2_sv_smo_drop_chance",
		serverConvar = "sv_smo_drop_chance",
		min = 0,
		max = 100,
		decimal = 0,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_smo_weapon_drop_chance",
	})
	general:MakeSlider({
		label = "label_ttt2_sv_smo_weapon_drop_chance",
		serverConvar = "sv_smo_weapon_drop_chance",
		min = 0,
		max = 100,
		decimal = 0,
	})
end