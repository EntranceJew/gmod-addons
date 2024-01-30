GM.Name = "Start Map Forward"
GM.Author = "EntranceJew"
GM.Email = "N/A"
GM.Website = "N/A"

local forward = function(ply, cmd, arg, argStr)
	debug.Trace()
	print(">>EJDEBUG>>:c", SysTime())
	RunConsoleCommand("gamemode", "terrortown")
	RunConsoleCommand("changelevel", "gm_construct")
end

function GM:PreGamemodeLoaded()
	print(">>EJDEBUG>>:g-pgl", SysTime())
	forward()
end

function GM:Initialize()
	print(">>EJDEBUG>>:g-i", SysTime())
	forward()
end

function GM:InitPostEntity()
	print(">>EJDEBUG>>:g-ipe", SysTime())
	forward()
end

function GM:OnEntityCreated(ent)
	print(">>EJDEBUG>>:g-oec", SysTime(), ent)
	forward()
end



concommand.Add("sv_start_map_forward", forward)