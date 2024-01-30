



local function UniqueList(tbl)
	local seen = {}
	local out = {}
	for i = 1, #tbl do
		local val = tbl[i]
		if not seen[val] then
			seen[val] = true
			out[#out + 1] = val
		end
	end
	return out
end




--CacheAll()

local ignored_wsids = {
	["3669c14c0bcac7df46b7d0007098191211d3802cc1fc86804684b310b9e2b199"] = true,
	["1357204556"] = true,
}

local function FindAllAddonsWithFileLike(name)
	for wsid, ws in pairs(deep_cache) do
		if ignored_wsids[wsid] then continue end

		for _, filename in ipairs(ws.files) do
			if string.find(filename, name, 1, true) then
				print(wsid, ws.title, filename)
			end
		end
	end
end



--FindAllAddonsWithFileLike("gamemodes/terrortown")
--FindAllAddonsWithFileLike("lua/terrortown")
--FindAllAddonsWithFileLike("lua/ttt2")



--[[
	1) all files that are basegame, or, whatever
	file.Find("*", "MOD")
	2) all files from the filesystem addon in question

	3) all files from the WORKSHOP addon in question

	4) all files ever from anywhere
]]

local function RemapPaths(paths, remaps)
	for i, path in ipairs(paths) do
		for _, remap in ipairs(remaps) do
			local st, en = string.find(path, remap[1], 1, true)
			if st == 1 and en then
				paths[i] = remap[2] .. string.sub(path, en + 1)
			end
		end
	end
	return paths
end

concommand.Add("smore_file_dedupe", function(ply, cmd, args, argStr)
	local tf, td = {}, {}
	tf, td = FindAllFiles("*", "gamemodes/terrortown/", tf, td, "MOD")
	tf = UniqueList(tf)
	tf, td = FindAllFiles("*", "addons/TTT2/", tf, td, "MOD")
	tf = RemapPaths(tf, {
		{"addons/TTT2/", ""},
	})
	tf = UniqueList(tf)

	CacheAll()

	for _, path in ipairs(tf) do
		FindAllAddonsWithFileLike(path)
	end
end,
"Runs deduplication logic.")