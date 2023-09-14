local feat = {}

TTT2SMORE.HookAdd("OnDamagedByExplosion", "tinnitus_disable", function()
	if GetConVar("sv_smore_tinnitus_disable"):GetBool() then return true end
end)

TTT2SMORE.HookAdd("SMORECreateConVars", "tinnitus_disable", function()
	TTT2SMORE.MakeCVar("tinnitus_disable", "0")
end)

TTT2SMORE.HookAdd("SMOREServerAddonSettings", "tinnitus_disable", function(parent, general)
	TTT2SMORE.MakeElement(general, "tinnitus_disable", "MakeCheckBox")
end)

TTT2SMORE.AddFeature("TinnitusDisable", feat)
