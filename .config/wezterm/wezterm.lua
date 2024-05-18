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

config.automatically_reload_config = true
config.front_end = "WebGpu"
config.term = "xterm-256color"
local colors, color_conf, window_conf = dofile(os.getenv('HOME') .. '/.config/wezterm/colors.lua')

-- Window
config.font = wezterm.font_with_fallback {
    { family = 'JetBrainsMono Nerd Font', weight = 'Medium' },
    { family = 'Hack Nerd Font', weight = 'Bold' },
    }
config.freetype_load_target = "Light"
-- config.colors = color_conf
-- config.color_scheme = 'Modus-Vivendi-Deuteranopia'
config.color_scheme = 'Moonfly (Gogh)'
config.cursor_blink_rate = 10

-- Tab Bar
wezterm.on('update-right-status', function(window, pane)
  window:set_left_status ' '
end)
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_max_width = 100
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false


-- Frame
config.window_frame = window_conf
config.check_for_updates = true
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

if string.find(io.popen('uname'):read('*a'), 'Darwin') then
    local main_resolution = tonumber(io.popen('system_profiler SPDisplaysDataType | grep Resolution | awk \'{print $2}\' | head -n 1'):read('*a'))
    config.default_prog = {'/opt/homebrew/bin/fish'}
    if main_resolution > 3000 then 
        config.font_size = 17.0
    else
        config.font_size = 13.0
    end
    -- config.window_decorations = "RESIZE"
elseif string.find(io.popen('uname'):read('*a'), 'Linux') then
    config.default_prog = {'/usr/bin/fish'}
    config.font_size = 13
    config.window_decorations = "RESIZE"
end

return config

