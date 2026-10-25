local programs = require("hyprland.programs")
local main_mod = "SUPER"
local ws_mod = "CTRL"

hl.bind(main_mod .. " + T", hl.dsp.exec_cmd(programs.terminal))
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(programs.file_manager))
hl.bind(main_mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + space", hl.dsp.exec_cmd(programs.menu))
hl.bind(main_mod .. " + P", hl.dsp.layout("togglesplit"))
hl.bind(main_mod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Notifications
hl.bind(main_mod .. " + N", hl.dsp.exec_cmd("dunstctl history-pop"))
hl.bind(main_mod .. " + SHIFT + N", hl.dsp.exec_cmd("dunstctl close-all"))

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]]))

-- Move focus and windows.
local directions = { h = "left", l = "right", k = "up", j = "down" }
for key, direction in pairs(directions) do
    hl.bind(ws_mod .. " + " .. key, hl.dsp.focus({ direction = direction }))
    hl.bind(ws_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

-- Switch workspaces or move the active window to one; 0 selects workspace 10.
for workspace = 1, 10 do
    local key = workspace % 10
    hl.bind(ws_mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(ws_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace, follow = true }))
end

-- Special workspace (scratchpad)
hl.bind(ws_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(ws_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", follow = true }))

-- Scroll through existing workspaces.
hl.bind(ws_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(ws_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows.
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness, also while locked.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl.
-- hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
-- hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
