local wezterm = require("wezterm")

disable_default_super_key_bindings = {
	{ key = "-", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "0", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "1", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "2", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "3", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "4", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "5", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "6", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "7", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "8", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "9", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "=", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "[", mods = "SHIFT|SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "]", mods = "SHIFT|SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "c", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "f", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "k", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "m", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "n", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "r", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "t", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "v", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "w", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "{", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "{", mods = "SHIFT|SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "}", mods = "SUPER", action = wezterm.action.DisableDefaultAssignment },
	{ key = "}", mods = "SHIFT|SUPER", action = wezterm.action.DisableDefaultAssignment },
}

-- Modify color scheme to use a fully black background color
local flexoki_custom = wezterm.color.get_builtin_schemes()["flexoki-dark"]
flexoki_custom.background = "black"

return {
	font = wezterm.font("MesloLGS NF", {
		weight = "Regular",
	}),
	adjust_window_size_when_changing_font_size = false,
	hide_tab_bar_if_only_one_tab = true,
	scrollback_lines = 10000,
	enable_scroll_bar = true,
	switch_to_last_active_tab_when_closing_tab = true,
	window_padding = {
		left = "5px",
		right = "5px",
		top = "5px",
		bottom = "5px",
	},
	keys = disable_default_super_key_bindings.keys,
	color_schemes = {
		["flexoki-custom"] = flexoki_custom,
	},
	color_scheme = "flexoki-custom",
	window_background_opacity = 0.90,
  -- bugfix.  using wezterm on nixos without front_end set, blocks of color
  -- are rendered in place of characters
  front_end = "WebGpu",
}
