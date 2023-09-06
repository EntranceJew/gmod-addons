--[[
Copyright Henk vd Laan 2020

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
--]]

-- this was originally provided via "https://steamcommunity.com/sharedfiles/filedetails/?id=2146015503"
-- but garrysmod did not want to allow it to be used (legacy *.bin format)
-- so here we are, shipping another hack
AddCSLuaFile()

-- Initialize the RNG one final time on server initialization
math.randomseed(os.time())

-- Warm it up
-- As we initialize based on a timestamp we'd like adjancent seeds to be
-- sufficiently different. Therefore we investigated randomness quality for
-- each byte for seeds that are 1000 seconds apart using a chi-square test.
-- Code can be found on https://gist.github.com/JustHev/42c5fc970bb75ddb17e8128a5c29ef98
-- For Linux around 30 calls are needed to reach an acceptable quality
-- For Windows we'd need more than 1000, so we'll pretend 30 calls is okay

local goal = system.IsWindows() and 1000 or 30
for _ = 1, goal do
	math.random()
end

-- Now disable randomseed for everyone else
local dev = GetConVar("developer")
math.randomseed = function()
	if not dev:GetBool() then return end
	print("BanRandomSeed: Someone tried to call math.randomseed, they shouldn't! Attempt blocked.")
	print(debug.traceback())
end
