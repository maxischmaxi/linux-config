local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28

config.font_size = 12.0
config.color_scheme = "Tokyo Night"

config.hide_tab_bar_if_only_one_tab = true

config.keys = {
	{
		key = "v",
		mods = "CTRL",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

return config
