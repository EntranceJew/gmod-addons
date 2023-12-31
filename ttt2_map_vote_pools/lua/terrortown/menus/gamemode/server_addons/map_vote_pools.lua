CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "map_vote_pools_addon_info"

local WriteMapData = function(wad)
	net.Start("MVP_AdminWriteMapData")
	net.WriteString(wad.map)
	net.WriteUInt(wad.min_players, 8)
	net.WriteUInt(wad.max_players, 8)
	net.SendToServer()
end

function CLGAMEMODESUBMENU:Populate(parent)
	net.Receive("MVP_AdminReturnMapData", function(len, ply)
		local map_name = net.ReadString()
		local min_players = net.ReadUInt(8)
		local max_players = net.ReadUInt(8)

		local wad = {
			map = map_name,
			min_players = min_players,
			max_players = max_players,
		}

		local current_map = vgui.CreateTTT2Form(parent, "map_vote_pools_settings_current_map")
		current_map:MakeHelp({
			label = "help_ttt2_ep_current_map",
			params = map_name
		})

		current_map:MakeSlider({
			label = "label_ttt2_ep_current_map_min_players",
			min = 0,
			max = game.MaxPlayers(),
			initial = min_players,
			OnChange = function(slf, newVal)
				wad.min_players = newVal
				WriteMapData(wad)
			end,
			decimal = 0
		})
		current_map:MakeSlider({
			label = "label_ttt2_ep_current_map_max_players",
			min = 0,
			max = game.MaxPlayers(),
			initial = max_players,
			OnChange = function(slf, newVal)
				wad.max_players = newVal
				WriteMapData(wad)
				-- print("debug: menu changed from",oldVal,"to",newVal,"via",slf)
			end,
			decimal = 0
		})

		current_map:MoveToBefore(parent:Find("map_vote_pools_settings_score"))
	end)

	net.Start("MVP_AdminRequestMapData")
	net.SendToServer()

	local score = vgui.CreateTTT2Form(parent, "map_vote_pools_settings_score")

	score:MakeHelp({
		label = "help_ttt2_sv_mvp_skip_sort",
	})
	score:MakeCheckBox({
		label = "label_ttt2_sv_mvp_skip_sort",
		serverConvar = "sv_mvp_skip_sort"
	})

	score:MakeHelp({
		label = "help_ttt2_sv_mvp_score_uninducted",
	})
	score:MakeSlider({
		label = "label_ttt2_sv_mvp_score_uninducted",
		serverConvar = "sv_mvp_score_uninducted",
		min = -1000,
		max =  1000,
		decimal = 0,
	})
	score:MakeHelp({
		label = "help_ttt2_sv_mvp_score_play_count_penalty",
	})
	score:MakeSlider({
		label = "label_ttt2_sv_mvp_score_play_count_penalty",
		serverConvar = "sv_mvp_score_play_count_penalty",
		min = -1000,
		max =  1000,
		decimal = 0,
	})
	score:MakeHelp({
		label = "help_ttt2_sv_mvp_score_cooldown_penalty",
	})
	score:MakeSlider({
		label = "label_ttt2_sv_mvp_score_cooldown_penalty",
		serverConvar = "sv_mvp_score_cooldown_penalty",
		min = -1000,
		max =  1000,
		decimal = 0,
	})
	score:MakeHelp({
		label = "help_ttt2_sv_mvp_score_map_too_big",
	})
	score:MakeSlider({
		label = "label_ttt2_sv_mvp_score_map_too_big",
		serverConvar = "sv_mvp_score_map_too_big",
		min = -1000,
		max =  1000,
		decimal = 0,
	})
	score:MakeHelp({
		label = "help_ttt2_sv_mvp_score_insufficient_spawns",
	})
	score:MakeSlider({
		label = "label_ttt2_sv_mvp_score_insufficient_spawns",
		serverConvar = "sv_mvp_score_insufficient_spawns",
		min = -1000,
		max =  1000,
		decimal = 0,
	})
	score:MakeHelp({
		label = "help_ttt2_sv_mvp_score_nomination_value",
	})
	score:MakeSlider({
		label = "label_ttt2_sv_mvp_score_nomination_value",
		serverConvar = "sv_mvp_score_nomination_value",
		min = -1000,
		max =  1000,
		decimal = 0,
	})

	local interface = vgui.CreateTTT2Form(parent, "map_vote_pools_settings_interface")
	interface:MakeHelp({
		label = "help_ttt2_sv_mvp_use_chat_commands",
	})
	interface:MakeCheckBox({
		label = "label_ttt2_sv_mvp_use_chat_commands",
		serverConvar = "sv_mvp_use_chat_commands"
	})

	interface:MakeHelp({
		label = "help_ttt2_sv_mvp_use_ulx_commands",
	})
	interface:MakeCheckBox({
		label = "label_ttt2_sv_mvp_use_ulx_commands",
		serverConvar = "sv_mvp_use_ulx_commands"
	})

	-- interface:MakeHelp({
	-- 	label = "help_ttt2_sv_mvp_ui_panel_use_image",
	-- })
	-- interface:MakeCheckBox({
	-- 	label = "label_ttt2_sv_mvp_ui_panel_use_image",
	-- 	serverConvar = "sv_mvp_ui_panel_use_image"
	-- })

	interface:MakeHelp({
		label = "help_ttt2_sv_mvp_ui_severity_scale",
	})
	interface:MakeSlider({
		label = "label_ttt2_sv_mvp_ui_severity_scale",
		serverConvar = "sv_mvp_ui_severity_scale",
		min = 0,
		max = 5,
		decimal = 2,
	})
	interface:MakeHelp({
		label = "help_ttt2_sv_mvp_ui_icon_blackout_rate",
	})
	interface:MakeSlider({
		label = "label_ttt2_sv_mvp_ui_icon_blackout_rate",
		serverConvar = "sv_mvp_ui_icon_blackout_rate",
		min = 0,
		max = 1,
		decimal = 2,
	})
	interface:MakeHelp({
		label = "help_ttt2_sv_mvp_ui_icon_tile_columns",
	})
	interface:MakeSlider({
		label = "label_ttt2_sv_mvp_ui_icon_tile_columns",
		serverConvar = "sv_mvp_ui_icon_tile_columns",
		min = 0,
		max = 16,
		decimal = 0,
	})
	interface:MakeHelp({
		label = "help_ttt2_sv_mvp_ui_icon_scale",
	})
	interface:MakeSlider({
		label = "label_ttt2_sv_mvp_ui_icon_scale",
		serverConvar = "sv_mvp_ui_icon_scale",
		min = 64,
		max = 512,
		decimal = 0,
	})
	interface:MakeHelp({
		label = "help_ttt2_sv_mvp_ui_avatar_alpha",
	})
	interface:MakeSlider({
		label = "label_ttt2_sv_mvp_ui_avatar_alpha",
		serverConvar = "sv_mvp_ui_avatar_alpha",
		min = 0,
		max = 255,
		decimal = 0,
	})



	local rtv = vgui.CreateTTT2Form(parent, "map_vote_pools_settings_rtv")

	rtv:MakeHelp({
		label = "help_ttt2_sv_mvp_rtv_player_count",
	})
	rtv:MakeSlider({
		label = "label_ttt2_sv_mvp_rtv_player_count",
		serverConvar = "sv_mvp_rtv_player_count",
		min = 0,
		max = 128,
		decimal = 0,
	})

	rtv:MakeHelp({
		label = "help_ttt2_sv_mvp_rtv_ratio",
	})
	rtv:MakeSlider({
		label = "label_ttt2_sv_mvp_rtv_ratio",
		serverConvar = "sv_mvp_rtv_ratio",
		min = 0,
		max = 1,
		decimal = 2,
	})

	rtv:MakeHelp({
		label = "help_ttt2_sv_mvp_rtv_wait",
	})
	rtv:MakeSlider({
		label = "label_ttt2_sv_mvp_rtv_wait",
		serverConvar = "sv_mvp_rtv_wait",
		min = 0,
		max = 300,
		decimal = 0,
	})

	local nominate = vgui.CreateTTT2Form(parent, "map_vote_pools_settings_nominate")

	nominate:MakeHelp({
		label = "help_ttt2_sv_mvp_nominate_limit_map_print",
	})
	nominate:MakeSlider({
		label = "label_ttt2_sv_mvp_nominate_limit_map_print",
		serverConvar = "sv_mvp_nominate_limit_map_print",
		min = 0,
		max = 32,
		decimal = 0,
	})

	local general = vgui.CreateTTT2Form(parent, "map_vote_pools_settings_general")

	general:MakeHelp({
		label = "help_ttt2_sv_mvp_map_limit",
	})
	general:MakeSlider({
		label = "label_ttt2_sv_mvp_map_limit",
		serverConvar = "sv_mvp_map_limit",
		min = 0,
		max = 128,
		decimal = 0,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_mvp_time_limit",
	})
	general:MakeSlider({
		label = "label_ttt2_sv_mvp_time_limit",
		serverConvar = "sv_mvp_time_limit",
		min = 0,
		max = 120,
		decimal = 0,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_mvp_allow_current_map",
	})
	general:MakeCheckBox({
		label = "label_ttt2_sv_mvp_allow_current_map",
		serverConvar = "sv_mvp_allow_current_map"
	})

	general:MakeHelp({
		label = "help_ttt2_sv_mvp_enable_cooldown",
	})
	general:MakeCheckBox({
		label = "label_ttt2_sv_mvp_enable_cooldown",
		serverConvar = "sv_mvp_enable_cooldown"
	})

	general:MakeHelp({
		label = "help_ttt2_sv_mvp_cooldown_use_penalty",
	})
	general:MakeCheckBox({
		label = "label_ttt2_sv_mvp_cooldown_use_penalty",
		serverConvar = "sv_mvp_cooldown_use_penalty"
	})

	general:MakeHelp({
		label = "help_ttt2_sv_mvp_maps_before_revote",
	})
	general:MakeSlider({
		label = "label_ttt2_sv_mvp_maps_before_revote",
		serverConvar = "sv_mvp_maps_before_revote",
		min = 0,
		max = 128,
		decimal = 0,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_mvp_sync_with_rsm",
	})
	general:MakeCheckBox({
		label = "label_ttt2_sv_mvp_sync_with_rsm",
		serverConvar = "sv_mvp_sync_with_rsm"
	})
	general:MakeHelp({
		label = "help_ttt2_sv_mvp_map_prefixes",
	})
	general:MakeTextEntry({
		label = "label_ttt2_sv_mvp_map_prefixes",
		serverConvar = "sv_mvp_map_prefixes",
		-- OnChange = function(...) print("g.mte.oc:", ...) end,
	})

	general:MakeHelp({
		label = "help_ttt2_sv_mvp_map_whitelist_enabled",
	})
	general:MakeCheckBox({
		label = "label_ttt2_sv_mvp_map_whitelist_enabled",
		serverConvar = "sv_mvp_map_whitelist_enabled"
	})
	general:MakeHelp({
		label = "help_ttt2_sv_mvp_map_whitelist",
	})
	general:MakeTextEntry({
		label = "label_ttt2_sv_mvp_map_whitelist",
		serverConvar = "sv_mvp_map_whitelist",
	})

	general:MakeHelp({
		label = "help_ttt2_sv_mvp_map_blacklist_enabled",
	})
	general:MakeCheckBox({
		label = "label_ttt2_sv_mvp_map_blacklist_enabled",
		serverConvar = "sv_mvp_map_blacklist_enabled"
	})
	general:MakeHelp({
		label = "help_ttt2_sv_mvp_map_blacklist",
	})
	general:MakeTextEntry({
		label = "label_ttt2_sv_mvp_map_blacklist",
		serverConvar = "sv_mvp_map_blacklist",
	})

	general:MakeHelp({
		label = "help_ttt2_sv_mvp_auto_gamemode",
	})
	general:MakeCheckBox({
		label = "label_ttt2_sv_mvp_auto_gamemode",
		serverConvar = "sv_mvp_auto_gamemode"
	})

	local debug = vgui.CreateTTT2Form(parent, "map_vote_pools_settings_debug")
	debug:MakeHelp({
		label = "help_ttt2_sv_mvp_debug",
	})
	debug:MakeCheckBox({
		label = "label_ttt2_sv_mvp_debug",
		serverConvar = "sv_mvp_debug"
	})
	debug:MakeHelp({
		label = "help_ttt2_sv_mvp_debug_random_min_max",
	})
	debug:MakeCheckBox({
		label = "label_ttt2_sv_mvp_debug_random_min_max",
		serverConvar = "sv_mvp_debug_random_min_max"
	})
end