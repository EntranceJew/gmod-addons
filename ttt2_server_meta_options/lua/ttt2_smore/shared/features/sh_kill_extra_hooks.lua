local feat = {}

TTT2SMORE.HookAdd("PostInitPostEntity", "kill_extra_hooks", function()
	if not GetConVar("sv_smore_kill_extra_hooks"):GetBool() then return end

	hook.Remove("TTTBeginRound", "BeginRoundDetectiveSkin")
end)

TTT2SMORE.HookAdd("SMORECreateConVars", "kill_extra_hooks", function()
	TTT2SMORE.MakeCVar("kill_extra_hooks", "0")
end)

TTT2SMORE.HookAdd("SMOREServerAddonSettings", "kill_extra_hooks", function(parent, general)
	TTT2SMORE.MakeElement(general, "kill_extra_hooks", "MakeCheckBox")
end)

TTT2SMORE.AddFeature("KillExtraHooks", feat)
