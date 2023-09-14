L = LANG.GetLanguageTableReference("en")

L["propspec_nogrief_addon_info"] = "PropSpec NoGrief"

L["propspec_nogrief_settings_possession"] = "Possession"

L["label_ttt2_sv_psng_ghost_alpha"] = "Ghost Alpha"
L["help_ttt2_sv_psng_ghost_alpha"] = "The transparency to apply to possessed props."
L["label_ttt2_sv_psng_transparent_render_mode"] = "Transparent Render Mode"
L["help_ttt2_sv_psng_transparent_render_mode"] = "Set props to force their render mode to transparent.\nMay cause some props to appear invisible all the time if the Ghost Alpha setting is not tuned correctly."


L["propspec_nogrief_settings_general"] = "General"
L["label_ttt2_sv_psng_debug_print"] = "Debug Print"
L["help_ttt2_sv_psng_debug_print"] = "Allow print messages to console for debugging problems."
L["label_ttt2_sv_psng_think_interval"] = "Think Interval (seconds)"
L["help_ttt2_sv_psng_think_interval"] = "How long between checks for all addon operations.\nAffects performance, but only marginally."
L["label_ttt2_sv_psng_resolidify_all_clear_wait"] = "All Clear Wait (seconds)"
L["help_ttt2_sv_psng_resolidify_all_clear_wait"] = "The time to wait after all resolidify conditions are met.\nThis prevents things from becoming solid as soon as they touch the ground, or once a player is just out of range."
L["label_ttt2_sv_psng_resolidify_only_grounded"] = "Resolidify Only If Grounded"
L["help_ttt2_sv_psng_resolidify_only_grounded"] = "Do not allow resolidification to begin unless on the ground."
L["label_ttt2_sv_psng_resolidify_grounded_check_distance"] = "Resolidify Ground Check Distance"
L["help_ttt2_sv_psng_resolidify_grounded_check_distance"] = "How far underneath a prop to check for the world."
L["label_ttt2_sv_psng_resolidify_grounded_min_time"] = "Resolidify Grounded Duration Minimum (seconds)"
L["help_ttt2_sv_psng_resolidify_grounded_min_time"] = "How long to wait before becoming solid again.\nThis prevents things from becoming solid the moment they touch a world brush, but are still tumbling."
L["label_ttt2_sv_psng_ejection_radius"] = "Ejection Radius"
L["help_ttt2_sv_psng_ejection_radius"] = "Forcibly prevent spectators from either posesssing or being in possession of a player under this distance."

L["propspec_nogrief_settings_contents"] = "PhysObj Contents"
L["label_ttt2_sv_psng_physobj_contents"] = "PhysObj Contents"
L["help_ttt2_sv_psng_physobj_contents"] = "The CONTENTS value controls the collision behavior.\nCONTENTS_GRATE is ignored by bullets, but has other issues."