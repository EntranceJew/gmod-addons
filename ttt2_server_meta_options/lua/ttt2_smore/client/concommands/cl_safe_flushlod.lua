concommand.Add("smore_safe_flush_lod", function(ply, cmd, args, argStr)
	hook.Add("PreRender","TTT2SMORE_FlushLODNoCrash",function()
		local re_enable_mcore = GetConVar("gmod_mcore_test"):GetString() == "1"
		if re_enable_mcore then
		  RunConsoleCommand("gmod_mcore_test", "0")
		end
		RunConsoleCommand("r_flushlod")
		if re_enable_mcore then
		  RunConsoleCommand("gmod_mcore_test", "1")
		end
		hook.Remove("PreRender","TTT2SMORE_FlushLODNoCrash")
		return true
	end)
end,
"Buffers a r_flushlod during a situation where it won't crash your client.")