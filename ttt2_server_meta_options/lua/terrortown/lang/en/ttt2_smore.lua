L = LANG.GetLanguageTableReference("en")

L["door_open_stealth"] = "Press [{usekey}] to open door, press [{walkkey} + {usekey}] for quiet open."
L["door_close_stealth"] = "Press [{usekey}] to close door, press [{walkkey} + {usekey}] for quiet close."

L["smore_all_role_notify_extra_credits"] = "You have recieved {credits} extra credit(s) for the amount of players this round!"
L["smore_hurry_up"] = "{seconds} seconds remaining, all players have radar!"
L["smore_hurry_up_extended"] = "Round was extended, gifted radars removed."

L["smore_defi_error_player_role"] = "You can't revive this player because they're {role}."
L["smore_defi_error_player_disconnect_refund"] = "You were refunded {cost} credit(s) because that no-good player disconnected."


-- Server Addons > SMORE
L["smore_addon_info"] = "SMORE"

-- Server Addons > SMORE > General
L["smore_settings_general"] = "General"

L["label_ttt2_sv_smore_round_start_ammo_bonus"] = "Round Start Ammo Bonus"
L["help_ttt2_sv_smore_round_start_ammo_bonus"] = "At the beginning of every round, players will be awarded extra ammo for their equipped weapon. This factor is scaled against the clip size of their active weapon.\n0 = disabled, 1 = regular clip"

L["label_ttt2_sv_smore_tie_breaker_enable"] = "Tie Breaker Enable"
L["help_ttt2_sv_smore_tie_breaker_enable"] = "In the event a round would tie, allow declaring a particular team to be the winner."
L["label_ttt2_sv_smore_tie_breaker_win_team_only"] = "Tie Breaker Win Team Only"
L["help_ttt2_sv_smore_tie_breaker_win_team_only"] = "Only allow teams that are marked as being able to win to win tie breakers."
L["label_ttt2_sv_smore_tie_breaker_was_alive"] = "Tie Breaker Was Alive"
L["help_ttt2_sv_smore_tie_breaker_was_alive"] = "Only allow teams that had a living member the previous time the win check was run. This effectively prevents a team that had no surviving members early in the round from inexplicably winning a tie breaker."
L["label_ttt2_sv_smore_tie_breaker_team_priority"] = "Tie Breaker Team Priority"
L["help_ttt2_sv_smore_tie_breaker_team_priority"] = [[A list of teams that will be chosen from, in order of left-to-right, to win a tie breaker. If a team's name is not listed here, then it cannot win a tie breaker, despite any other options.
Separate each item with "|"

List of valid teams are: {teams}]]

L["label_ttt2_sv_smore_voice_max_distance_enable"] = "Voice Max Distance Enable"
L["help_ttt2_sv_smore_voice_max_distance_enable"] = "Allow capping the max range the player can hear voice from, hard cutoff without attenuation.\nPrevents disorienting moments where proximity voices may be heard from the map origin."
L["label_ttt2_sv_smore_voice_max_distance_range"] = "Voice Max Distance Range"
L["help_ttt2_sv_smore_voice_max_distance_range"] = "The maximum distance a voice can be heard from."

L["label_ttt2_sv_smore_tinnitus_disable"] = "Tinnitus Disable"
L["help_ttt2_sv_smore_tinnitus_disable"] = "Causes your ears to no longer ring when explosions go off around you."

L["label_ttt2_sv_smore_hurry_up_min_time"] = "Hurry Up Min Time"
L["help_ttt2_sv_smore_hurry_up_min_time"] = "The time remaining in which all players will be given radar."

L["label_ttt2_sv_smore_hurry_up_max_time"] = "Hurry Up Max Time"
L["help_ttt2_sv_smore_hurry_up_max_time"] = "The time remaining in which all players will have gifted radars revoked.\nIf giving the radars out resulted in many kills, then take the radars back."

L["label_ttt2_sv_smore_kill_extra_hooks"] = "Kill Extra Hooks"
L["help_ttt2_sv_smore_kill_extra_hooks"] = [[Forcibly removes hooks that are undesired, such as:

- Detective Playermodel
  It's recommended to use SMORE's built-in Sub-Role Model override if you're still using an addon that sets this.
]]

-- Server Addons > SMORE > Mechanic: Door Stealth/Haste Open
L["smore_settings_mechanic_door_stealth_and_haste_open"] = "Mechanic: Door Stealth/Haste Open"

L["label_ttt2_sv_smore_door_stealth_and_haste_open_reset_hesitation"] = "Reset Hesitation"
L["help_ttt2_sv_smore_door_stealth_and_haste_open_reset_hesitation"] = "The factor of how long to wait before a door will discard its speed after being hastily opened or closed.\nOnly tweak when doors are misbehaving."

L["label_ttt2_sv_smore_door_stealth_open_enable"] = "Door Stealth-Open Enable"
L["help_ttt2_sv_smore_door_stealth_open_enable"] = "Allow players to open doors quietly while holding the walk key."

L["label_ttt2_sv_smore_door_stealth_open_speed_modifier"] = "Speed Modifier"
L["help_ttt2_sv_smore_door_stealth_open_speed_modifier"] = "The speed by which a stealthily opened door opening will open, as a factor against its original."

L["label_ttt2_sv_smore_door_stealth_open_volume_modifier"] = "Volume Modifier"
L["help_ttt2_sv_smore_door_stealth_open_volume_modifier"] = "The loudness that a stealthily opened door opening will be, as a factor against its original."

L["label_ttt2_sv_smore_door_haste_open_enable"] = "Door Haste-Open Enable"
L["help_ttt2_sv_smore_door_haste_open_enable"] = "Allow players to open doors expediently while holding the sprint key."

L["label_ttt2_sv_smore_door_haste_open_speed_modifier"] = "Speed Modifier"
L["help_ttt2_sv_smore_door_haste_open_speed_modifier"] = "The speed by which a hastily opened door opening will open, as a factor against its original."

L["label_ttt2_sv_smore_door_haste_open_volume_modifier"] = "Volume Modifier"
L["help_ttt2_sv_smore_door_haste_open_volume_modifier"] = "The loudness that a hastily opened door opening will be, as a factor against its original."

L["label_ttt2_sv_smore_door_haste_open_reset_hesitation"] = "Reset Hesitation"
L["help_ttt2_sv_smore_door_haste_open_reset_hesitation"] = "The factor of how long to wait before a hastily opened door will reset itself, taken against the distance it travels to open."

-- Server Addons > SMORE > Mechanic: Bot Options
L["smore_settings_mechanic_bot_options"] = "Mechanic: Bot Options"

L["label_ttt2_sv_smore_prevent_bot_roles"] = "Prevent Bot Roles"
L["help_ttt2_sv_smore_prevent_bot_roles"] = "When bot players are active, roles will randomly be removed from them and distributed to human players."
L["label_ttt2_sv_smore_bot_quota"] = "Bot Quota"
L["help_ttt2_sv_smore_bot_quota"] = "The number of bots the server should add to achieve a minimum playercount.\nThis is useful to test certain playercount breakpoints with roles."
L["label_ttt2_sv_smore_bot_pickup_nearby_range"] = "Pickup Nearby Range"
L["help_ttt2_sv_smore_bot_pickup_nearby_range"] = "When a bot is within this range of an item, they will pick it up.\n0 = Disabled"
L["label_ttt2_sv_smore_bot_spawn_command"] = "Spawn Command"
L["help_ttt2_sv_smore_bot_spawn_command"] = "The command to use to spawn bots, if there are fewer than you'd like."

-- Edit Equipment > * > Additional Equipment Settings

-- Edit Equipment > Defibrillator > Additional Equipment Settings
L["label_ttt2_sv_smore_equipment_weapon_ttt_defibrillator_disconnect_refund"] = "Disconnect Refund"
L["help_ttt2_sv_smore_equipment_weapon_ttt_defibrillator_disconnect_refund"] = "Reward the cost of a defibrillator to a player that attempts to revive a disconnected player."

-- Edit Equipment > Turret > Additional Equipment Settings
L["label_ttt2_sv_smore_equipment_weapon_ttt_turret_weight"] = "Turret Weight"
L["help_ttt2_sv_smore_equipment_weapon_ttt_turret_weight"] = "A multiplier against the weight of the turret, which controls how easy it is to topple or relocate."

-- Role Settings > Swapper > SMORE: Infected / General
L["header_roles_smore_inf_general"] = "SMORE: Infected / General"

L["label_ttt2_sv_smore_inf_zombie_loadout_append_items"] = "Zombie Loadout Ammend Items"
L["help_ttt2_sv_smore_inf_zombie_loadout_append_items"] = "A list of item class names to give zombies spawned by this role in addition to its regular loadout.\nSeparate each item with \"|\"."

L["label_ttt2_sv_smore_inf_zombie_loadout_append_weapons"] = "Zombie Loadout Ammend Weapons"
L["help_ttt2_sv_smore_inf_zombie_loadout_append_weapons"] = "A list of weapon class names to give zombies spawned by this role in addition to its regular loadout.\nSeparate each weapon with \"|\"."

L["label_ttt2_sv_smore_inf_zombie_loadout_detach_items"] = "Zombie Loadout Detach Items"
L["help_ttt2_sv_smore_inf_zombie_loadout_detach_items"] = "A list of item class names to take away from zombies spawned by this role's regular loadout.\nSeparate each item with \"|\"."

L["label_ttt2_sv_smore_inf_zombie_loadout_detach_weapons"] = "Zombie Loadout Detach Weapons"
L["help_ttt2_sv_smore_inf_zombie_loadout_detach_weapons"] = "A list of weapon class names to take away from zombies spawned by this role's regular loadout.\nSeparate each weapon with \"|\"."

-- Role Settings > Swapper > SMORE: Swapper / General
L["header_roles_smore_swa_general"] = "SMORE: Swapper / General"

L["label_ttt2_sv_smore_swa_shared_damage_enabled"] = "Shared Damage"
L["help_ttt2_sv_smore_swa_shared_damage_enabled"] = "Whether or not to hurt every person that damaged the swapper after they die."

L["label_ttt2_sv_smore_swa_shared_damage_multiplier"] = "Shared Damage Multiplier"
L["help_ttt2_sv_smore_swa_shared_damage_multiplier"] = "The scale of the damage that should accumulate, lower for less than real damage, higher for more than real damage."

L["label_ttt2_sv_smore_swa_shared_damage_survive_health"] = "Shared Damage Survive Health"
L["help_ttt2_sv_smore_swa_shared_damage_survive_health"] = "The amount of health that a player should survive with if hurting the swapper would kill them. Set to 0 allow them to die."

-- Role Settings > * > SMORE: All Roles / General
L["header_roles_smore_all_role_general"] = "SMORE: All Roles / General"

L["label_ttt2_sv_smore_all_role_sub_role_model"] = "Sub-Role Model"
L["help_ttt2_sv_smore_all_role_sub_role_model"] = "The model that this role should be forcibly assigned to all members of this role."

L["label_ttt2_sv_smore_all_role_prohibit_revive"] = "Prohibit Revive"
L["help_ttt2_sv_smore_all_role_prohibit_revive"] = "Roles with this enabled will not be allowed to be defibrillated."

L["label_ttt2_sv_smore_all_role_prevent_same_team_damage"] = "Prevent Damaging Team"
L["help_ttt2_sv_smore_all_role_prevent_same_team_damage"] = "Prevents the role from doing damage to other roles in the same team.\nThis does not prevent the other role from damaging this one, unless it also has this option checked."
L["label_ttt2_sv_smore_all_role_prevent_same_subrole_damage"] = "Prevent Damaging SubRole"
L["help_ttt2_sv_smore_all_role_prevent_same_subrole_damage"] = "Prevents the role from doing damage to other players with the exact same role."

L["label_ttt2_sv_smore_all_role_shop_editor_listening_enabled"] = "Shop Editor Listener Enable"
L["help_ttt2_sv_smore_all_role_shop_editor_listening_enabled"] = "Allow this role to subscribe to all changes to the listed roles' shops when they are edited.\nConsider disabling this checkbox temporarily if you are going to completely undo your shops, then enabling after sorting out the basics."
L["label_ttt2_sv_smore_all_role_shop_editor_listening_roles"] = "Shop Editor Listener"
L["help_ttt2_sv_smore_all_role_shop_editor_listening_roles"] = [[A list of role names. When you change the shop of a listed role, this role will also be edited similarly. Adding, or removing will cause it to happen to this role as well.
A good use for this would be linking the Defective shop to both the Traitor and Detective.
Separate each item with "|"

List of valid roles are: {roles}]]

L["label_ttt2_sv_smore_all_role_extra_credits_min_players"] = "Extra Credits Minimum Players"
L["help_ttt2_sv_smore_all_role_extra_credits_min_players"] = "The minimum amount of players required for extra credits to be distributed based on player count."

L["label_ttt2_sv_smore_all_role_extra_credits_players_per_credit"] = "Extra Credits Players Per Credit"
L["help_ttt2_sv_smore_all_role_extra_credits_players_per_credit"] = "The number of players past the minimum to trigger a credit being awarded.\nIf the minimum is 8, and this value is 2 then 1 credit will be given out at 10 players, 2 credits will be given out at 12 players, etc."

L["label_ttt2_sv_smore_all_role_loadout_append_items"] = "Loadout Ammend Items"
L["help_ttt2_sv_smore_all_role_loadout_append_items"] = "A list of item class names to give this role in addition to its regular loadout.\nSeparate each item with \"|\"."

L["label_ttt2_sv_smore_all_role_loadout_append_weapons"] = "Loadout Ammend Weapons"
L["help_ttt2_sv_smore_all_role_loadout_append_weapons"] = "A list of weapon class names to give this role in addition to its regular loadout.\nSeparate each weapon with \"|\"."

L["label_ttt2_sv_smore_all_role_loadout_detach_items"] = "Loadout Detach Items"
L["help_ttt2_sv_smore_all_role_loadout_detach_items"] = "A list of item class names to take away from this role's regular loadout.\nSeparate each item with \"|\"."

L["label_ttt2_sv_smore_all_role_loadout_detach_weapons"] = "Loadout Detach Weapons"
L["help_ttt2_sv_smore_all_role_loadout_detach_weapons"] = "A list of weapon class names to take away from this role's regular loadout.\nSeparate each weapon with \"|\"."
