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
config.term = "xterm-256color"

-- Window
config.font = wezterm.font('FiraCode Nerd Font', {weight="Regular", stretch="Normal", style="Normal"})
config.front_end = "WebGpu"
config.freetype_load_flags = 'NO_HINTING'
config.freetype_render_target = 'HorizontalLcd'

config.bold_brightens_ansi_colors = false
config.color_scheme = 'Jellybeans (Gogh)'
config.cursor_blink_rate = 10

-- Tab Bar
wezterm.on('update-right-status', function(window, pane)
  window:set_left_status ' '
end)
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.tab_max_width = 100
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

-- Frame
config.check_for_updates = true
config.window_background_opacity = 1.0
config.text_background_opacity = 1.0

if string.find(io.popen('uname'):read('*a'), 'Darwin') then
    local main_resolution = tonumber(io.popen('system_profiler SPDisplaysDataType | grep Resolution | awk \'{print $2}\' | head -n 1'):read('*a'))
    config.default_prog = {'/opt/homebrew/bin/fish'}
    if main_resolution > 3000 then 
        config.font_size = 16
    elseif main_resolution == 1920 then 
        config.font_size = 13
    else
        config.font_size = 12
    end
    config.window_decorations = "TITLE | RESIZE"
elseif string.find(io.popen('uname'):read('*a'), 'Linux') then
    config.default_prog = {'/usr/bin/fish'}
    config.font_size = 13
    config.window_decorations = "RESIZE"
end

return config
