hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )

hl.bind(
    "SUPER + Space",
    hl.dsp.exec_cmd("hyprctl switchxkblayout current next"),
    { description = "Switch layout" }
)
