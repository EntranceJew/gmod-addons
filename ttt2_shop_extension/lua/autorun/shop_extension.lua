if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("shop_extension/shared/sh_shop_extension.lua")

	include("shop_extension/shared/sh_shop_extension.lua")
else
	include("shop_extension/shared/sh_shop_extension.lua")
end
