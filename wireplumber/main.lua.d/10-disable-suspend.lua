-- Disable suspend for all audio devices
table.insert(alsa_monitor.rules, {
	matches = {
		{ { "node.name", "matches", "alsa_output.*" } },
		{ { "node.name", "matches", "alsa_input.*" } },
	},
	apply_properties = {
		["session.suspend-timeout-seconds"] = 0,
	},
})
