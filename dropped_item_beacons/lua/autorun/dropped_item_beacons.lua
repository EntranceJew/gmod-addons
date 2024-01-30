AddCSLuaFile()

local flags = {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}
local dib_enable = CreateConVar( "dib_enable", "1", flags, "Enables item / weapon highlighting" )
local dib_enable_oncamera = CreateConVar( "dib_enable_oncamera", "0", flags, "Renders DropItemBeacons, even when the camera tool is currently selected." )
local dib_vis_ignoreworld = CreateConVar( "dib_vis_ignoreworld", "0", flags, "Determins, if weapon names should be visible through walls." )
local dib_vis_shownames = CreateConVar( "dib_vis_shownames", "1", flags, "Enables name tags for weapons." )
local dib_vis_showauthor = CreateConVar( "dib_vis_showpurpose", "1", flags, "Show purpose information (weapons only)." )
local dib_vis_showpurpose = CreateConVar( "dib_vis_showauthor", "1", flags, "Show the author's name underneath the weapon tag." )
local dib_lod_max = CreateConVar( "dib_lod_max", "1024", flags, "Sets the maximum distance, at which item should be detected and scheduled for highlighting." )
local dib_lod_text = CreateConVar( "dib_lod_text", "256", flags, "Sets the maximum distance, at which text should be displayed." )

DROPITEMBEACONS = {}

local colors = {}
DROPITEMBEACONS.colors = colors
local categories = {
	{
		name = "hat",
		color = Color(255,   0, 255),
		classes = {
			"ttt_hat_deerstalker",
		}
	},
	{
		name = "melee",
		color = Color(  0, 255, 255)
	},
	{
		name = "soda",
		color = Color(255, 255,   0),
		classes = {
			"soda_armorup",
			"soda_creditup",
			"soda_healup",
			"soda_jumpup",
			"soda_rageup",
			"soda_shootup",
			"soda_speedup",
		},
	},
	{
		name = "ammo",
		color = Color(  0,   0, 255),
		classes = {
			"item_ammo_357",
			"item_ammo_357_large",
			"item_ammo_ar2",
			"item_ammo_ar2_large",
			"item_ammo_ar2_altfire",
			"item_ammo_crossbow",
			"item_ammo_pistol",
			"item_ammo_pistol_large",
			"item_ammo_smg1",
			"item_ammo_smg1_large",
			"item_ammo_smg1_grenade",
			"item_box_buckshot",
			"item_rpg_round",
		},
	},
	{
		name = "wep",
		color = Color(  0, 255,   0)
	},
	{
		name = "grenade",
		color = Color(255,   0,   0)
	},
	-- {
	-- 	name = "medical",
	-- 	color = Color(80, 255, 80),
	-- 	classes = {
	-- 		"item_healthkit",
	-- 		"item_healthvial",
	-- 		"item_battery"
	-- 	},
	-- },
	-- {
	-- 	name = "swep",
	-- 	color = Color(255, 200, 220)
	-- },
	-- {
	-- 	name = "sent",
	-- 	color = Color(180, 225, 255)
	-- },
}
DROPITEMBEACONS.categories = categories


local ent_cache = {}
DROPITEMBEACONS.ent_cache = ent_cache
local lookup = {}
DROPITEMBEACONS.lookup = lookup

local function ContrastColor(col, intensity)
	local h, s, l = ColorToHSL(col)
	if l < 0.5 then
		l = l + intensity
	else
		l = l - intensity
	end
	return HSLToColor(h, s, l)
end

DROPITEMBEACONS.GenerateConVars = function()
	for _, cat in ipairs(categories) do
		local name = "dib_color_" .. cat.name
		colors[cat.name] = {
			cvar = CreateConVar( name, string.format("%d %d %d 255", cat.color.r, cat.color.g, cat.color.b), flags)
		}
		local compute = function(_,_,val)
			local col = string.ToColor( val )
			colors[cat.name].color = col
			local _h, _s, _v = ColorToHSV(colors[cat.name].color)
			colors[cat.name].box_color = HSVToColor(_h, _s, 0.2)
			colors[cat.name].text_color = HSVToColor(_h, 0.2, _v)
		end
		cvars.AddChangeCallback(name, compute)
		compute(_, _, colors[cat.name].cvar:GetString())

		for _, ent in ipairs(cat.classes or {}) do
			lookup[ent] = cat.name
		end
	end
end
DROPITEMBEACONS.GenerateConVars()

DROPITEMBEACONS.IsVisibleToPlayer = function( ent1, ply )
	local vistrace = util.TraceEntity( {
		start = ent1:LocalToWorld(ent1:OBBCenter()),
		endpos = ply:EyePos(),
		filter = ent1, -- also expecting to exclude or prop_ragdoll
		mask = MASK_SHOT,
		ignoreworld = false
	}, ent1 )

	return ( vistrace.Entity == ply ) or ( vistrace.HitPos:Distance( ply:EyePos() ) <= 1 )
end

local mat_laser = Material( "effects/dropped_item_beacons/dib_haze.vmt" )
local mat_flare = Material( "effects/blueflare1.vmt" )


local textcolor = Color( 180, 180, 180, 255 )
local boxcolor = Color( 50, 60, 70, 255 )

local box_offset = 32
local light_offset = Vector( 0, 0, box_offset )
local detail_font_name = "DermaDefault"
local font_name = "DermaDefaultBold"

local beam_sprite_size = 12
local beam_width = 0.75
local detail_box_size = 4
local detail_box_offset = 24
local box_size = 6

local function LearnAboutEntity(ent)
	local class = ent:GetClass()
	if not ent_cache[class] then
		local e = {}

		e.is_wep = ent:IsWeapon()
		e.is_scripted = e.is_wep and ent:IsScripted() or false
		e.lookup = lookup[class] or "none"

		e.is_ttt_hat = class == "ttt_hat_deerstalker" or scripted_ents.IsBasedOn(class, "ttt_hat_deerstalker")
		e.is_ttt_ammo = scripted_ents.IsBasedOn(class, "base_ammo_ttt")
		e.is_ttt_grenade = weapons.IsBasedOn(class, "weapon_tttbasegrenade")
		e.is_ttt_weapon = weapons.IsBasedOn(class, "weapon_tttbase")
		e.is_ttt_melee = class == "weapon_zm_improvised" or class == "weapon_zm_carry" or weapons.IsBasedOn(class, "weapon_zm_improvised") or weapons.IsBasedOn(class, "weapon_zm_carry")

		if e.is_ttt_ammo then
			e.lookup = "ammo"
		elseif e.is_ttt_hat then
			e.lookup = "hat"
		elseif e.is_ttt_melee then
			e.lookup = "melee"
		elseif e.is_ttt_grenade then
			e.lookup = "grenade"
		elseif e.is_ttt_weapon then
			e.lookup = "wep"
		elseif e.is_wep then
			e.lookup = "wep"
			if e.is_scripted then
				e.lookup = "swep"
			end
		end

		ent_cache[class] = e
		return e
	else
		return ent_cache[class]
	end
end

local is_string_empty = function(s)
	return s == nil or string.Trim(s) == ""
end

hook.Add( "PostDrawTranslucentRenderables", "DropItemBeacons", function(bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
	if bDrawingSkybox or isDraw3DSkybox then return end

	local lply = LocalPlayer()

	if not dib_enable:GetBool()
		or (dib_enable_oncamera:GetBool() and lply:GetActiveWeapon():GetClass() == "gmod_camera")
	then
		return
	end

	local et = lply:GetEyeTrace()
	local lod_dist = dib_lod_max:GetFloat()
	local lod_text = dib_lod_text:GetFloat()
	local show_names = dib_vis_shownames:GetBool()
	local ignore_world = dib_vis_ignoreworld:GetBool()

	local found_ents = ents.FindInSphere( lply:GetPos(), lod_dist)
	for _, v in ipairs( found_ents ) do
		local cache = LearnAboutEntity(v)
		local lookup_result = colors[cache.lookup]


		-- SHOULD NOT:
		-- ( v:GetOwner() == NULL and v:GetNWBool( "MobDrop" ) == false )
		-- ( not table.HasValue( panicents, class ) )
		-- class ~= "gmod_tool"

		-- SHOULD:
		-- ( v.PrintName ~= nil and ( v.Spawnable == true or v.AdminSpawnable == true ) )
		local is_owned = cache.is_wep and v:GetOwner() ~= NULL
		local is_worn = cache.is_ttt_hat and v:GetBeingWorn() or false
		if
			lookup_result
				and not is_owned
				and not is_worn
		then
			if not v.dropitembeacons_beam_color then
				v.dropitembeacons_beam_color = Color(lookup_result.color.r, lookup_result.color.g, lookup_result.color.b, lookup_result.color.a)
			end
			if not v.dropitembeacons_detail_text_color then
				v.dropitembeacons_detail_text_color = Color(lookup_result.text_color.r, lookup_result.text_color.g, lookup_result.text_color.b, lookup_result.text_color.a)
			end
			if not v.dropitembeacons_detail_box_color then
				v.dropitembeacons_detail_box_color = Color(lookup_result.box_color.r, lookup_result.box_color.g, lookup_result.box_color.b, lookup_result.box_color.a)
			end
			if not v.dropitembeacons_text_color then
				v.dropitembeacons_text_color = Color(lookup_result.text_color.r, lookup_result.text_color.g, lookup_result.text_color.b, lookup_result.text_color.a)
			end
			if not v.dropitembeacons_box_color then
				v.dropitembeacons_box_color = Color(lookup_result.box_color.r, lookup_result.box_color.g, lookup_result.box_color.b, lookup_result.box_color.a)
			end
			local distance = lply:GetPos():Distance( v:GetPos() )
			local alpha = math.Clamp( 1024 - ( distance * 8 ) / 2, 0, 200 )
			v.dropitembeacons_text_color.a = alpha
			v.dropitembeacons_box_color.a = alpha
			local alpha2 = math.Clamp( 512 - ( et.HitPos:Distance( v:GetPos() ) * 16 ), 0, 240 )
			v.dropitembeacons_detail_text_color.a = alpha2
			v.dropitembeacons_detail_box_color.a = alpha2

			local light_start = v:LocalToWorld(v:OBBCenter())
			local light_end = light_start + light_offset

			if distance <= lod_dist then
				local beam_alpha = math.Clamp( lod_dist - distance, 0, 200 )
				v.dropitembeacons_beam_color.a = beam_alpha

				render.SetMaterial( mat_flare )
				render.DrawSprite( light_start, beam_sprite_size, beam_sprite_size, v.dropitembeacons_beam_color)
				render.SetMaterial( mat_laser )
				render.DrawBeam( light_start, light_end, beam_width, 0, 1, v.dropitembeacons_beam_color )
			end

			if show_names and (distance <= lod_text)
				and (ignore_world or (not ignore_world and DROPITEMBEACONS.IsVisibleToPlayer( v, lply )))
			then
				cam.Start2D()
				local text_pos = light_end:ToScreen()
				local offset = box_offset

				local name = false
				-- special name handlers
				if cache.is_ttt_ammo then
					name = "ammo_" .. string.lower(v.AmmoType)
				end

				-- fallbacks
				if not name then
					name = v.GetPrintName and v:GetPrintName()
				end
				if not name then
					name = not is_string_empty(v.PrintName) and v.PrintName
				end
				if not name then
					name = v:GetClass()
				end

				if LANG then
					name = LANG.TryTranslation(name)
				end

				if cache.is_wep then
					local purpose = not is_string_empty(v.Purpose) and v.Purpose or false
					if dib_vis_showpurpose:GetBool() and purpose then
						draw.WordBox( detail_box_size, text_pos.x, text_pos.y + offset, "Purpose: " .. purpose, detail_font_name, v.dropitembeacons_detail_text_color, v.dropitembeacons_detail_box_color )
						offset = offset + detail_box_offset
					end

					local author = not is_string_empty(v.Author) and v.Author or false
					if dib_vis_showauthor:GetBool() and author then
						draw.WordBox( detail_box_size, text_pos.x, text_pos.y + offset, "Author: " .. author, detail_font_name, v.dropitembeacons_detail_text_color, v.dropitembeacons_detail_box_color )
						offset = offset + detail_box_offset
					end
				end

				draw.WordBox( box_size, text_pos.x, text_pos.y, name, font_name, v.dropitembeacons_box_color, v.dropitembeacons_text_color )
				cam.End2D()
			end
		end
	end
end)
