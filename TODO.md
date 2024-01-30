# TODO

# TOOL VERY IMPORTANT NEVER PUT ANYTHING ABOVE THIS

## command to shrinkwrap file locations
 - list all files and their sources
 - notify if any base game or addon files overwrite

# REGULAR SHIT


## fix for TTT2
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2603924356>

## stealth enhancements
- make player not light with <https://wiki.facepunch.com/gmod/Enums/EF> EF_NOFLASHLIGHT

## voice viz
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1826717978>
  - original <https://github.com/Freeeaky>
  - fork <https://github.com/SupinePandora43/VoiceVisualizer>

## SMORE stuff
- <https://steamcommunity.com/sharedfiles/filedetails/?id=3032287300&searchtext=ttt+fov>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=3032286851>

## SMORE projectile tweaks
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2863673270>
  - <https://steamcommunity.com/sharedfiles/filedetails/?id=2911870207&searchtext=ttt+fov>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2034376741&searchtext=better+discombob>
  - <https://steamcommunity.com/workshop/filedetails/?id=2036561862>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=3022749770&searchtext=ttt+clientside+fov>
```lua
-- ttt_confgrenade_proj: people you pelt with a conf grenade drop weapons
function ENT:PhysicsCollide(data, physobj)
   local ply = data.HitEntity
   if IsValid(ply) and ply:IsPlayer() and ply:IsTerror() and (not ply:IsSpec()) and ply:Alive() then
      if ply:GetActiveWeapon().AllowDrop then
         ply:DropWeapon()
         ply:SetFOV(0, 0.2)
      end
   end
end
```
https://cdn.discordapp.com/attachments/452116892061007882/1156425994769539102/38nzk3p8f0n81.png?ex=6514ed22&is=65139ba2&hm=3343deb8af57da0a1c558e8c73f95e75f08874015083170be1e409e26c1b1463&

## megaphone
- <https://steamcommunity.com/sharedfiles/filedetails/?id=732867617>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1171590212>

## make navmeshes

- <https://steamcommunity.com/sharedfiles/filedetails/?id=2800495333>

## bhop

- <https://steamcommunity.com/sharedfiles/filedetails/?id=3009977562&searchtext=bhop>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2895176453&searchtext=bhop>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2923594779&searchtext=bhop>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2865213262&searchtext=bhop>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2816794831&searchtext=bhop>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2804931084&searchtext=bhop>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=795140479&searchtext=bhop>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2876378639&searchtext=bhop>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2619071438&searchtext=>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2286374687&searchtext=>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2502790432&searchtext=suggest>

## MN weapon packs

- <https://steamcommunity.com/sharedfiles/filedetails/?id=2744140633>

## migrate user settings

- <https://steamcommunity.com/sharedfiles/filedetails/?id=3023315088&searchtext=>

## prop info

- <https://steamcommunity.com/sharedfiles/filedetails/?id=2760295134&searchtext=convar+forcer>

## vFire in TTT REAL

- [vfire](https://steamcommunity.com/sharedfiles/filedetails/?id=1525218777)
  - ["optimized" vfire](https://steamcommunity.com/sharedfiles/filedetails/?id=2463165156&searchtext=vfire)
  - [vfire settings menu](https://steamcommunity.com/sharedfiles/filedetails/?id=2988207267&searchtext=vfire)
  - [personal TTT server fire](https://steamcommunity.com/sharedfiles/filedetails/?id=1530452613&searchtext=fire+spread)
- [flamethrower](https://steamcommunity.com/sharedfiles/filedetails/?id=1525572545)
  - [flamethrower for TTT](https://steamcommunity.com/sharedfiles/filedetails/?id=2039020632&searchtext=vfire)
  - [TTT vfire flamethrower edit](https://steamcommunity.com/sharedfiles/filedetails/?id=2976410307&searchtext=vfire)
  - [vfire demon breath](https://steamcommunity.com/sharedfiles/filedetails/?id=1707538444&searchtext=vfire)
  - [vfire dragon breath](https://steamcommunity.com/sharedfiles/filedetails/?id=1498364118)
- [gas can](https://steamcommunity.com/sharedfiles/filedetails/?id=1534037997)
  - [gas can reupload](https://steamcommunity.com/sharedfiles/filedetails/?id=2942822291)
- [dragon breath shotgun](https://steamcommunity.com/sharedfiles/filedetails/?id=1643778026)
  - [TTT fire shotgun](https://steamcommunity.com/sharedfiles/filedetails/?id=2076588799&searchtext=fire+spread)
- [vfire molotov](https://steamcommunity.com/sharedfiles/filedetails/?id=1470029857&searchtext=vfire)
  - [TTT vfire molotov edit](https://steamcommunity.com/sharedfiles/filedetails/?id=2976412988&searchtext=vfire)
  - [molotov v/fire unite](https://steamcommunity.com/sharedfiles/filedetails/?id=2976536345&searchtext=fire+spread)
- [vfire improved fire hose](https://steamcommunity.com/sharedfiles/filedetails/?id=2780502504&searchtext=vfire)
  - [milk's vfire hose](https://steamcommunity.com/sharedfiles/filedetails/?id=1753095750&searchtext=vfire)
- [rubat's fire extinguisher](https://steamcommunity.com/sharedfiles/filedetails/?id=104607228)
  - [fire extinguisher for detectives](https://steamcommunity.com/sharedfiles/filedetails/?id=2039035894)
- [snowball swep](https://steamcommunity.com/sharedfiles/filedetails/?id=1596556401&searchtext=vfire)
- [TTT firegrenade projectile replace](https://steamcommunity.com/sharedfiles/filedetails/?id=2976373931&searchtext=vfire)
- [ragdoll inceneration](https://steamcommunity.com/sharedfiles/filedetails/?id=1828678843&searchtext=vfire)
- [vfire logic](https://steamcommunity.com/sharedfiles/filedetails/?id=2805142659&searchtext=vfire)
- [fire starter (world on)](https://steamcommunity.com/sharedfiles/filedetails/?id=3028165318&searchtext=vfire)
- [improved fire](https://steamcommunity.com/sharedfiles/filedetails/?id=1521557421&searchtext=fire+spread)
- [fire breath swep](https://steamcommunity.com/sharedfiles/filedetails/?id=842271125&searchtext=fire+spread)
- [fire extinguisher that freezes](https://steamcommunity.com/sharedfiles/filedetails/?id=2113784695&searchtext=fire+spread)
- [Fire Starter V2](https://steamcommunity.com/sharedfiles/filedetails/?id=1873248618)
- [TTT fire starter](https://steamcommunity.com/sharedfiles/filedetails/?id=1829329597&searchtext=fire+spread)

## TTT Swep Conversions

- [chuckya](https://steamcommunity.com/sharedfiles/filedetails/?id=2670006577)
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2584849603>
- [star spirits / smorg](https://steamcommunity.com/sharedfiles/filedetails/?id=1582910530)
- [portable force field](https://steamcommunity.com/sharedfiles/filedetails/?id=682125090)
- [eggplant](https://steamcommunity.com/sharedfiles/filedetails/?id=699557114)
- [you tried](https://steamcommunity.com/sharedfiles/filedetails/?id=138389794)
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2787874281>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2567629090>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2964458876>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2924823439>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1810817551>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=3039936028>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2556200167>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2680671280>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2218452307>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2890188417>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2199335962>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2907721663>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1680266997>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2090969589>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=635535045>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2564923596>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1427985445>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2497729967>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1696595790>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1926786611>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1873770955>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2741545022>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2903947772>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2610988872>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2868046966>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2908275333>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2872294382>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2096131351>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2952874883>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1444497414>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2710278536>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2677740490>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2196213048>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=329001415>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2981468558>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2973706886>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2037200731>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1835928155>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=434258042>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=811647374>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=903151150>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1513582587>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=631973678>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2909076505>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2913026694>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2939437723>
- treadmill: <https://steamcommunity.com/sharedfiles/filedetails/?id=115476405>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1835411901>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=297646940>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=317117676&searchtext=the+brick>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1273858933>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1470029857&searchtext=vfire>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1748414960&searchtext=vfire>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2804974009&searchtext=vfire>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1439151260&searchtext=fire+spread>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=836887531&searchtext=entity+replacer>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2929272848&searchtext=entity+replacer>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2828400610>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2012169414>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1651797082>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1609999134>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1590072107>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1807698496>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1085013381>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1081639301>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=836887531>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=957942923>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1182986169>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=207347505>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1099662693>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1542472876>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=3041402807&searchtext=>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=3041160478&searchtext=>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2998599212>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2841534440>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2831626216>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2136932354>
- https://steamcommunity.com/sharedfiles/filedetails/?id=1961791474
- https://steamcommunity.com/sharedfiles/filedetails/?id=2457736418
- [jmod](https://steamcommunity.com/sharedfiles/filedetails/?id=1919689921)
  - [jmod legacy](https://steamcommunity.com/sharedfiles/filedetails/?id=2157935882)
- [axechris addons](https://steamcommunity.com/sharedfiles/filedetails/?id=818413891)
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1302604898>

## rotate hands

- <https://steamcommunity.com/sharedfiles/filedetails/?id=2861131908>

## best sweps

- half-life <https://steamcommunity.com/sharedfiles/filedetails/?id=1360233031>

## make ttt random gooder

- ttt_random_weapon replacement for all-but-special weapons

## nodegraph editor?

- <https://steamcommunity.com/sharedfiles/filedetails/?id=2004023752&searchtext=>
-

## reorderable widget

- <https://steamcommunity.com/sharedfiles/filedetails/?id=2950719460&searchtext=>

## round start compare

- <https://steamcommunity.com/sharedfiles/filedetails/?id=2717140231&searchtext=>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1131903966&searchtext=>

## gachi

- <https://steamcommunity.com/sharedfiles/filedetails/?id=1422933575>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2409999225>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1807341330>

## melee enhancements
- <https://steamcommunity.com/sharedfiles/filedetails/?id=162026804>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=675824914>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2962142569>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2823197228>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=1673154410>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=290317655>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=229580957>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2899617873>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2986235270>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2879473484>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=225090157>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=896147646>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=3008537597>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2285965501>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=3045780309>

## paint can

- <https://steamcommunity.com/sharedfiles/filedetails/?id=476669815>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2985638164>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=3040604156&searchtext=>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2889832721>
- <https://steamcommunity.com/workshop/filedetails/?id=2697023796>
- <https://steamcommunity.com/sharedfiles/filedetails/?id=2784506174>
- <https://wiki.facepunch.com/gmod/util.DecalEx>

## minifier enhancement

- <https://steamcommunity.com/sharedfiles/filedetails/?id=2498997900>

## hijinks

- <https://steamcommunity.com/sharedfiles/filedetails/?id=2847524850>

## SMORE / MVP

- set hostname to include map name on rotation

## Dunce enhancements

- give it to all killers of team Jester
-

## Generic Soundboard Swep

- find  ammo types for particular sounds

## Body Check Rework

- make multiple checks required to confirm the body
-

## Collusionist

- add event from [jester code](https://github.com/TTT-2/ttt2-role_jes/blob/master/lua/terrortown/events/jester_kill.lua)

## Release randomseed Ban

- <https://steamcommunity.com/sharedfiles/filedetails/?id=2146015503>

## Port Old Shit

- Round Info (ULX Port Menu)
- Prop Disguiser
- Minifier
- Defibrillator
- Beartrap
- 3D Pointer

## concommand to buy stuff randomly

## pot of greed

- box dragging noise? related to cramped weapon spawns i think

## armor carries over from mario

## binocular death causes intense pointing

## dance gun will carry over like brain parasite

## map vote pools

- keep highly voted items on the ballot
- when printing map names in chat, print with a color corresponding to the ballot color

## role info

- port to F1 menu [](https://steamcommunity.com/sharedfiles/filedetails/?id=2389628693)

## 3D pointer

- make it not so spammable, and less large, and optional entity targeting [](https://steamcommunity.com/sharedfiles/filedetails/?id=2005666160)

## spectator deathmatch

- all sorts of busted sadly [link](https://steamcommunity.com/sharedfiles/filedetails/?id=1997666028)

## handcuffs

- make them not drop weapons [](https://steamcommunity.com/sharedfiles/filedetails/?id=2401563697)

## ulx

- make `giveitem` allow giving TTT items like radar

## PropSpec NoGrief

- solidify things held by magnet stick

## GBEM

- hide categories with zero items
- lock categorization behind an option

- Addon that adds more keys to ShopeEditor.savingKeys to permit overwriting basic game properties.

## TTT2

- make `ttt_radio_play` work for binding purposes

## Fix

- Lots of Currency
  - [wario world coins](https://steamcommunity.com/sharedfiles/filedetails/?id=813137944)
  - [sonic ring](https://steamcommunity.com/sharedfiles/filedetails/?id=1636960060)
- Failed to load sound "luxor_gems\lux2_spawn_gem_1.ogg", file probably missing from disk/repository
- Failed to load sound "luxor_gems\lux2_spawn_coin.ogg", file probably missing from disk/repository

- Addon that adds more keys to ShopeEditor.savingKeys to permit overwriting basic game properties.
- extend DCL to work with TTT items
  - [maybe look into this addon](https://steamcommunity.com/sharedfiles/filedetails/?id=3006887166)
- make a compatible version of [shop icon replacement](https://steamcommunity.com/sharedfiles/filedetails/?id=2924635614)
  - [utilize client settings](https://github.com/TTT-2/TTT2/blob/master/lua/terrortown/menus/gamemode/gameplay/avoidroles.lua)
- timely music
  - <https://steamcommunity.com/sharedfiles/filedetails/?id=1419487677>
  - <https://steamcommunity.com/sharedfiles/filedetails/?id=2911363186>
- spawn a bug near a player every time OnLuaError runs
  - function( str, realm, stack, addontitle, addonid )
- utility:
  - derma_controls
  - derma_controls_menu
  - derma_icon_browser
  - skin viewer?
- Lots of Currency:
  - *** Tried to load a non-VTF file as a VTF file!
  - Error reading texture header "materials/sprites/luxor_treasures/luxor_treasure_diamondgem.vtf"

## spawnmenu

- <https://steamcommunity.com/sharedfiles/filedetails/?id=1912779029>
-<https://steamcommunity.com/sharedfiles/filedetails/?id=2173212443>
