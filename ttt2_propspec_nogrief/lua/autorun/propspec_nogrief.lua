PropSpec_NoGrief = PropSpec_NoGrief or {}
-- TODO: maybe replace grounding check with stationary check

print("what the deuce")

if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("propspec_nogrief/client/cl_propspec_nogrief_menu.lua")

	-- include("propspec_nogrief/client/cl_propspec_nogrief_menu.lua")
	include("propspec_nogrief/server/sv_propspec_nogrief.lua")
else
	-- ok
	-- x x 
	-- include("propspec_nogrief/client/cl_propspec_nogrief_menu.lua")
end
