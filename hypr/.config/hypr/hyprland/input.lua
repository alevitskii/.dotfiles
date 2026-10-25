hl.config({
    input = {
        kb_layout = "us,ru",
        kb_variant = "",
        kb_model = "",
        kb_options = "grp:alt_shift_toggle,caps:super",
        kb_rules = "",

        follow_mouse = 1,
        sensitivity = 0.0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.device({
    name = "logitech-m280/320/275-1",
    sensitivity = -0.5,
})
