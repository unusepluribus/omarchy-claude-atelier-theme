-- Claude Atelier: theme-local geometry, material and motion.
local active = { colors = { "rgba(d9775780)", "rgba(e8e6dc30)" }, angle = 45 }
hl.config({
  general = {
    gaps_in = 6, gaps_out = 12, border_size = 1,
    col = { active_border = active, inactive_border = "rgba(e8e6dc20)" },
  },
  group = { col = { border_active = active, border_inactive = "rgba(e8e6dc20)" } },
  decoration = {
    rounding = 16, active_opacity = 1.0, inactive_opacity = 1.0,
    shadow = { enabled = true, range = 24, render_power = 3, color = "rgba(00000045)" },
    blur = { enabled = true, size = 8, passes = 3, noise = 0.008, contrast = 0.98, brightness = 1.0 },
  },
})
-- No whole-window fading: content remains legible, terminals supply background alpha.
o.window({ tag = "default-opacity" }, { opacity = "1.0 1.0" })
o.window("^(Alacritty|foot|footclient|kitty|com\\.mitchellh\\.ghostty|org\\.omarchy\\.agent)$", { opacity = "1.0 1.0" })
hl.layer_rule({
  match = { namespace = "^omarchy-(bar|menu|clipboard|emojis|keyboard-panel|notifications|osd|reminders|network-qr)$" },
  blur = true, blur_popups = true, ignore_alpha = 0.2,
})
-- Brief transitions, very small scale change, no bounce.
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.4, bezier = "easeOutQuint", style = "popin 97%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.6, bezier = "almostLinear", style = "popin 97%" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2.0, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.4, bezier = "linear", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.2, bezier = "easeOutQuint", style = "slidefade 8%" })
