concommand.Add("smore_quick_mute", function(ply, cmd, args, argStr)
	local decode = {
		none   = MUTE_NONE,
		terror = MUTE_TERROR,
		all    = MUTE_ALL,
		spec   = MUTE_SPEC,
	}
	local real_state = decode[string.lower(args[1] or "none")] or MUTE_NONE
	local m = VOICE.CycleMuteState(real_state)

	RunConsoleCommand("ttt_mute_team", m)
end,
function(cmd, stringargs)
	--- Trim the arguments & make them lowercase.
	stringargs = string.Trim(stringargs:lower())
	--- Create a new table.
	local tbl = {"none", "terror", "all", "spec"}
	local out = {}
	for _, value in ipairs(tbl) do
		if value:find(stringargs) then
			--- Add the player's name into the auto-complete.
			value = cmd .. " " .. value
			table.insert(out, value)
		end
	end
	--- Return the table for auto-complete.
	return out
end,
"Set the TTT2 spectator voice mute to a specific value without cycling, valid values: none, terror, all, spec")