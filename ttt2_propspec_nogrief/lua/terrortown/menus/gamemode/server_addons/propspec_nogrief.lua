CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "propspec_nogrief_addon_info"

include("propspec_nogrief/client/cl_propspec_nogrief_menu.lua")

function CLGAMEMODESUBMENU:Populate(parent)
    local possession = vgui.CreateTTT2Form(parent, "propspec_nogrief_settings_possession")
    possession:MakeSlider({
        label = "label_ttt2_sv_psng_ghost_alpha",
        serverConvar = "sv_psng_ghost_alpha",
        min = 0,
        max = 255,
        decimal = 0
    })
    possession:MakeCheckBox({
        label = "label_ttt2_sv_psng_transparent_render_mode",
        serverConvar = "sv_psng_transparent_render_mode"
    })
    possession:MakeHelp({
        label = "help_ttt2_sv_psng_transparent_render_mode"
    })

    local general = vgui.CreateTTT2Form(parent, "propspec_nogrief_settings_general")
    general:MakeCheckBox({
        label = "label_ttt2_sv_psng_debug_print",
        serverConvar = "sv_psng_debug_print"
    })
    general:MakeHelp({
        label = "help_ttt2_sv_psng_debug_print"
    })

    general:MakeSlider({
        label = "label_ttt2_sv_psng_think_interval",
        serverConvar = "sv_psng_think_interval",
        min = 0,
        max = 60,
        decimal = 1
    })
    general:MakeHelp({
        label = "help_ttt2_sv_psng_think_interval"
    })

    general:MakeSlider({
        label = "label_ttt2_sv_psng_resolidify_all_clear_wait",
        serverConvar = "sv_psng_resolidify_all_clear_wait",
        min = 0,
        max = 60,
        decimal = 1
    })
    general:MakeHelp({
        label = "help_ttt2_sv_psng_resolidify_all_clear_wait"
    })

    general:MakeCheckBox({
        label = "label_ttt2_sv_psng_resolidify_only_grounded",
        serverConvar = "sv_psng_resolidify_only_grounded"
    })
    general:MakeHelp({
        label = "help_ttt2_sv_psng_resolidify_only_grounded"
    })

    general:MakeSlider({
        label = "label_ttt2_sv_psng_resolidify_grounded_check_distance",
        serverConvar = "sv_psng_resolidify_grounded_check_distance",
        min = 0,
        max = 60,
        decimal = 0
    })
    general:MakeHelp({
        label = "help_ttt2_sv_psng_resolidify_grounded_check_distance"
    })

    general:MakeSlider({
        label = "label_ttt2_sv_psng_resolidify_grounded_min_time",
        serverConvar = "sv_psng_resolidify_grounded_min_time",
        min = 0,
        max = 60,
        decimal = 0
    })
    general:MakeHelp({
        label = "help_ttt2_sv_psng_resolidify_grounded_min_time"
    })

    general:MakeSlider({
        label = "label_ttt2_sv_psng_ejection_radius",
        serverConvar = "sv_psng_ejection_radius",
        min = 0,
        max = 1000,
        decimal = 0
    })
    general:MakeHelp({
        label = "help_ttt2_sv_psng_ejection_radius"
    })

    --[[
    local contents = vgui.CreateTTT2Form(parent, "propspec_nogrief_settings_contents")
    contents:MakeFlagEnum({
        label = "label_ttt2_sv_psng_physobj_contents",
        serverConvar = "sv_psng_physobj_contents",
        enumPrefix = "CONTENTS_",
    })
    ]]
end
