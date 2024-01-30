if TTT2SMORE then TTT2SMORE.is_reload = true end
TTT2SMORE = TTT2SMORE or {
	is_reload = false,

	CVARS = {},
	RDATA = {}, -- round data
	PDATA = {}, -- persistent data

	RoundDataProto = {},

	Features = {},
	Mechanics = {},
	-- HookBay = {},
	-- RoleHooks = {},
}

local SCOPE_CLIENT = 1
local SCOPE_SERVER = 2
local SCOPE_SHARED = 3

TTT2SMORE.file_table = {
	{name = "sh_ttt2_smore.lua", scope = SCOPE_SHARED},

	-- shared
	{name = "concommands/sh_file_dedupe.lua", scope = SCOPE_SHARED},

	{name = "equipment/sh_weapon_ttt_defibrillator.lua", scope = SCOPE_SHARED},
	{name = "equipment/sh_weapon_ttt_force_shield.lua", scope = SCOPE_SHARED},
	{name = "equipment/sh_weapon_ttt_turret.lua", scope = SCOPE_SHARED},

	{name = "features/all_role/sh_all_role_extra_credits.lua", scope = SCOPE_SHARED},
	{name = "features/all_role/sh_all_role_loadout_editing.lua", scope = SCOPE_SHARED},
	{name = "features/all_role/sh_all_role_prevent_friendly_fire.lua", scope = SCOPE_SHARED},
	{name = "features/all_role/sh_all_role_shop_editor_listener.lua", scope = SCOPE_SHARED},
	{name = "features/all_role/sh_all_role_sub_role_model.lua", scope = SCOPE_SHARED},

	{name = "features/sh_extra_ammo.lua", scope = SCOPE_SHARED},
	{name = "features/sh_hurry_up.lua", scope = SCOPE_SHARED},
	{name = "features/sh_kill_extra_hooks.lua", scope = SCOPE_SHARED},
	{name = "features/sh_map_compat_neotokyo.lua", scope = SCOPE_SHARED},
	-- {name = "features/sh_player_pronouns.lua", scope = SCOPE_SHARED},
	{name = "features/sh_tie_breaker.lua", scope = SCOPE_SHARED},
	{name = "features/sh_tinnitus_disable.lua", scope = SCOPE_SHARED},
	{name = "features/sh_voice_max_distance.lua", scope = SCOPE_SHARED},

	{name = "mechanics/sh_bot_options.lua", scope = SCOPE_SHARED},
	{name = "mechanics/sh_door_stealth_and_haste_open.lua", scope = SCOPE_SHARED},

	{name = "roles/sh_infected.lua", scope = SCOPE_SHARED},
	{name = "roles/sh_swapper.lua", scope = SCOPE_SHARED},

	-- client
	{name = "concommands/cl_quick_mute.lua", scope = SCOPE_CLIENT},
	{name = "concommands/cl_safe_flushlod.lua", scope = SCOPE_CLIENT},
}

TTT2SMORE.file_times = {}

TTT2SMORE.ScanChanges = function()
	for _, script in pairs(TTT2SMORE.file_table) do
		local path = "ttt2_smore/"

		if script.scope == SCOPE_SHARED then
			path = path .. "shared/" .. script.name
		elseif script.scope == SCOPE_SERVER then
			path = path .. "server/" .. script.name
		elseif script.scope == SCOPE_CLIENT then
			path = path .. "client/" .. script.name
		end

		local new_time = file.Time(path, "LUA")
		if TTT2SMORE.file_times[path] ~= new_time then
			-- print("ScanChanges: file", path, "was", TTT2SMORE.file_times[path], "is now", new_time)
			return TTT2SMORE.LoadFiles()
		end
	end
end

TTT2SMORE.HookAdd = function(hook_name, hook_id, func)
	local long_id = "TTT2SMORE_" .. hook_name
	if hook_id ~= nil and hook_id ~= "" and type(hook_id) ~= "table" then
		long_id = long_id .. hook_id
	end
	hook.Remove(hook_name, long_id)
	hook.Add(hook_name, long_id, func)
end

TTT2SMORE.LoadFiles = function()
	for _, script in ipairs(TTT2SMORE.file_table) do
		local path = "ttt2_smore/"

		if script.scope == SCOPE_SHARED then
			path = path .. "shared/" .. script.name
		elseif script.scope == SCOPE_SERVER then
			path = path .. "server/" .. script.name
		elseif script.scope == SCOPE_CLIENT then
			path = path .. "client/" .. script.name
		end

		if SERVER and (script.scope == SCOPE_CLIENT or script.scope == SCOPE_SHARED) then
			AddCSLuaFile(path)
		end

		if script.scope == SCOPE_SHARED or (SERVER and script.scope == SCOPE_SERVER) or (CLIENT and script.scope == SCOPE_CLIENT) then
			include(path)
		end

		TTT2SMORE.file_times[path] = file.Time(path, "LUA")
	end
end

TTT2SMORE.ClearRoundData = function()
	TTT2SMORE.RDATA = table.Copy(TTT2SMORE.RoundDataProto)
end

TTT2SMORE.SlowThink = function()
	-- TTT2SMORE.ScanChanges()
	hook.Run("SMORESlowThink")
end

TTT2SMORE.PatchRole = function(role)
	if role.smore_patched then return end
	hook.Run("SMOREPatchRole", role)
	role.smore_patched = true
end

TTT2SMORE.TTTLanguageChanged = function()
	hook.Run("SMORETTTLanguageChanged")
end

-- TTT2SMORE.GameEventListen = function()
-- 	gameevent.Listen( "player_connect_client" )
-- end

TTT2SMORE.Init = function()
	TTT2SMORE.LoadFiles()

	hook.Run("SMORECreateConVars")

	local all_roles = roles.GetList()
	for _, role in ipairs(all_roles) do
		hook.Run("SMORECreateRoleConVars", role)

		TTT2SMORE.PatchRole(role)
	end

	hook.Run("SMOREPatchCoreTTT2")

	TTT2SMORE.TTTLanguageChanged()

	-- TTT2SMORE.GameEventListen()
end

TTT2SMORE.TTTBeginRound = function()
	TTT2SMORE.ClearRoundData()
	local alive = util.GetAlivePlayers()
	local alive_count = #alive

	for _, ply in ipairs(alive) do
		hook.Run("SMORETTTBeginRoundLivingPlayer", ply, alive_count)
	end

	timer.Simple(1, function()
		timer.Create("SMORESlowThink", 1, 0, TTT2SMORE.SlowThink)
	end)
end

TTT2SMORE.TTTEndRound = function()
	TTT2SMORE.ClearRoundData()
	local alive = util.GetAlivePlayers()
	local alive_count = #alive

	for _, ply in ipairs(alive) do
		hook.Run("SMORETTTEndRoundLivingPlayer", ply, alive_count)
	end
	timer.Remove("SMORESlowThink")
end

TTT2SMORE.HookAdd("PostInitPostEntity", "Init", TTT2SMORE.Init)
TTT2SMORE.HookAdd("TTTBeginRound", "TTTBeginRound", TTT2SMORE.TTTBeginRound)
TTT2SMORE.HookAdd("TTTEndRound", "TTTEndRound", TTT2SMORE.TTTEndRound)
TTT2SMORE.HookAdd("TTTLanguageChanged", "TTTLanguageChanged", TTT2SMORE.TTTLanguageChanged)

if TTT2SMORE.is_reload then
	TTT2SMORE.Init()
end