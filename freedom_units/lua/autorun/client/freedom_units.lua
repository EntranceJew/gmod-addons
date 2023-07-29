local are_we_free = util.SHA256(file.Read("resource/localization/en.png", "GAME"))
if are_we_free ~= "36cce5cae3d2e0045b2b2b6cbffdad7a0aba3e99919cc219bbf0578efdc45585" then
  print("Freedom Units:", "WARNING, YOU ARE NOT FREE! VISIT", "https://steamcommunity.com/sharedfiles/filedetails/?id=2586770483", "AND FOLLOW THE INSTRUCTIONS BETTER.")
end
local is_patriot = system.GetCountry() == "US" and cvars.String("cl_language") == "english" and cvars.String("gmod_language") == "en"
local is_depressing = system.IsOSX() or render.GetDXLevel() <= 80
local is_terrorist = function() return LocalPlayer():Ping() > 100 or 1/RealFrameTime() < 60 end