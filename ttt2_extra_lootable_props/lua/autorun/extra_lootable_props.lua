if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("extra_lootable_props/shared/sh_dtextentry_ttt2.lua")

	include("extra_lootable_props/server/sv_extra_lootable_props.lua")
end
