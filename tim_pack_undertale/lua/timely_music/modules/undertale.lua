AddCSLuaFile()
if GetConVar("cl_tim_debug_enable"):GetBool() then
  -- you don't need to do this it's just for checking hot reloads
  print("TimelyMusic:", "undertale loaded")
end
local undertale = TimelyMusic.MusicThemeInterface:new({})
function undertale:GetMusicForCondition(event_name, event_data)
  if not event_data.in_combat then
    for _, wname in ipairs(event_data.weather_chain) do
      -- print("gonna try to get weather for theme: ", wname)
      if #file.Find("sound/timely_music/undertale/ambient/weather/" .. wname .. "/*.wav", "GAME") > 0 then
        time = event_data.time_hours
        if time >= 06 and time < 18 then
          return "sound/timely_music/undertale/ambient/weather/" .. wname .. "/06.wav"
        elseif time >= 18 or time < 60 then
          return "sound/timely_music/undertale/ambient/weather/" .. wname .. "/18.wav"
        end
      end
    end
  end
end
TimelyMusic.AddTheme("undertale", undertale)
