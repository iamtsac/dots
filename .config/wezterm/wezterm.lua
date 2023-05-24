-- Pull in the wezterm API
local wezterm = require 'wezterm'
local os = require 'os'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.ssh_domains = {
  {
    -- This name identifies the domain
    name = 'ailab',
    -- The hostname or address to connect to. Will be used to match settings
    -- from your ssh config file
    remote_address = '150.140.142.98',
    -- The username to use on the remote host
    username = 'tsak',
    multiplexing = 'WezTerm',
  },
}

config.default_prog = {'/opt/homebrew/bin/fish'}
config.automatically_reload_config = true
config.front_end = "WebGpu"
config.term = "screen-256color"
local colors, color_conf, window_conf = dofile(os.getenv('HOME') .. '/.config/wezterm/colors.lua')

-- Window
config.font = wezterm.font {family = 'IosevkaTerm Nerd Font', weight = 'Medium'}
config.font_size = 17
config.freetype_load_target = "Light"
config.colors = color_conf
config.cursor_blink_rate = 0

-- Tab Bar
wezterm.on('update-right-status', function(window, pane)
  window:set_left_status ' '
end)
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.tab_max_width = 100
config.show_tab_index_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false


-- Frame
config.window_frame = window_conf
config.window_decorations = "RESIZE"
config.check_for_updates = false
config.window_background_opacity = 1.0
config.text_background_opacity = 1.0

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
    local name = window:active_key_table()
    if name then
	name = 'TABLE: ' .. name
    end
    window:set_right_status(name or '')
end)

-- local m = require "lua.mappings"
-- config = mappings(config)
return config
