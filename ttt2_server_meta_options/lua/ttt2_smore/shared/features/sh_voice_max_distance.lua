local feat = {}

feat.VoiceMaxDistance = function(listener, talker)
	-- TODO: use NikNaks.PAS to trace this problem separately
	-- TOOD: dig out my code from my message history from benj to do this more precisely with LOS dampening
	if not GetConVar("sv_smore_voice_max_distance_enable"):GetBool() then return end
	local dist = GetConVar("sv_smore_voice_max_distance_range"):GetFloat()
	local distSqr = dist * dist
	if IsValid(listener) and IsValid(talker)
		and not (listener:IsSpec() or talker:IsSpec())
		and listener:GetPos():DistToSqr(talker:GetPos()) > distSqr
	then
		return false
	end
end

TTT2SMORE.HookAdd("SMORECreateConVars", "hurry_up", function()
	TTT2SMORE.MakeCVar("voice_max_distance_enable", "0")
	TTT2SMORE.MakeCVar("voice_max_distance_range", "1000")
end)

TTT2SMORE.HookAdd("SMOREServerAddonSettings", "hurry_up", function(parent, general)
	TTT2SMORE.MakeElement(general, "voice_max_distance_enable", "MakeCheckBox")
	TTT2SMORE.MakeElement(general, "voice_max_distance_range", "MakeSlider", {max = 4000})
end)

if SERVER then
	TTT2SMORE.HookAdd("PlayerCanHearPlayersVoice", "voice_max_distance", feat.VoiceMaxDistance)
end

TTT2SMORE.AddFeature("HurryUp", feat)
