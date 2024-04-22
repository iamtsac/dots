local wezterm = require "wezterm"

local wezterm = require 'wezterm'

wezterm.on('toggle-colorscheme', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.color_scheme then
    overrides.color_scheme = 'Builtin Solarized Light'
  else
    overrides.color_scheme = nil
  end
  window:set_config_overrides(overrides)
end)

function mappings(config)
    config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
    config.keys = {

	{ key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
	{ key = '+', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
	{
	    key = '%',
	    mods = 'LEADER',
	    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
	},
	{
	    key = '"',
	    mods = 'LEADER',
	    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
	},
        {
            key = 'e',
            mods = 'LEADER',
            action = wezterm.action.EmitEvent 'toggle-colorscheme',
        },
	{
	    key = 'x',
	    mods = 'LEADER',
	    action = wezterm.action.CloseCurrentPane { confirm = true },
	},
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
	    key = 'r',
	    mods = 'LEADER',
	    action = wezterm.action.ActivateKeyTable {
		name = 'resize_pane',
		one_shot = false,
	    },
	},
	{ 
	    key = 'h',
	    mods = 'LEADER',
	    action = wezterm.action.ActivatePaneDirection 'Left' 
	},

	{ 
	    key = 'l',
	    mods = 'LEADER',
	    action = wezterm.action.ActivatePaneDirection 'Right' 
	},

	{ 
	    key = 'k',
	    mods = 'LEADER',
	    action = wezterm.action.ActivatePaneDirection 'Up' 
	},

	{
	    key = 'j',
	    mods = 'LEADER',
	    action = wezterm.action.ActivatePaneDirection 'Down' 
	},
    }
    config.key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	resize_pane = {
	    { key = 'LeftArrow', action = wezterm.action.AdjustPaneSize { 'Left', 1 } },
	    { key = 'h', action = wezterm.action.AdjustPaneSize { 'Left', 1 } },

	    { key = 'RightArrow', action = wezterm.action.AdjustPaneSize { 'Right', 1 } },
	    { key = 'l', action = wezterm.action.AdjustPaneSize { 'Right', 1 } },

	    { key = 'UpArrow', action = wezterm.action.AdjustPaneSize { 'Up', 1 } },
	    { key = 'k', action = wezterm.action.AdjustPaneSize { 'Up', 1 } },

	    { key = 'DownArrow', action = wezterm.action.AdjustPaneSize { 'Down', 1 } },
	    { key = 'j', action = wezterm.action.AdjustPaneSize { 'Down', 1 } },

	    -- Cancel the mode by pressing escape
	    { key = 'Escape', action = 'PopKeyTable' },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'activate_pane' here corresponds to the name="activate_pane" in
	-- the key assignments above.
    }
    return config
end
