-- Run once at session startup, rather than on every config reload.
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland")
    -- Store only text in clipboard history.
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
end)
