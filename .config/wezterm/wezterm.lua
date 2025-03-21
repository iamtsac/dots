-- Pull in the wezterm API
local wezterm = require("wezterm")
local os = require("os")

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.automatically_reload_config = true

if not file_exists(os.getenv("HOME") .. "/.terminfo/w/wezterm") then
    os.execute( "tempfile=$(mktemp) && curl -o $tempfile https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo && tic -x -o ~/.terminfo $tempfile && rm $tempfile")
end

config.term = "wezterm"

if string.find(io.popen("uname"):read("*a"), "Linux") and os.getenv("XDG_SESSION_TYPE") == "wayland" then
    config.enable_wayland = true
elseif string.find(io.popen("uname"):read("*a"), "Linux") and os.getenv("XDG_SESSION_TYPE") == "x11" then
    config.enable_wayland = false
end

-- Window
config.font = wezterm.font("SFMono Nerd Font Mono", {weight = "Regular"})
config.front_end = "WebGpu"
-- config.freetype_load_target = 'Normal'
-- config.freetype_load_flags = 'NO_HINTING'
config.font_shaper = 'Harfbuzz'

config.color_scheme_dirs = {'$HOME/.config/wezterm/colors/'}
config.bold_brightens_ansi_colors = false
config.color_scheme = "mellow"
config.default_cursor_style = 'SteadyBlock'

-- Tab Bar
wezterm.on("update-right-status", function(window, pane)
    window:set_left_status(" ")
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

if string.find(io.popen("uname"):read("*a"), "Darwin") then
    local main_resolution = tonumber(
        io.popen("system_profiler SPDisplaysDataType | grep Resolution | awk '{print $2}' | head -n 1"):read("*a")
    )
    config.default_prog = { "/opt/homebrew/bin/fish" }
    if main_resolution == 3840 then
        config.font_size = 16
    elseif main_resolution == 1920 then
        config.font_size = 13
    else
        config.font_size = 9
    end
    config.window_decorations = "TITLE | RESIZE"
elseif string.find(io.popen("uname"):read("*a"), "Linux") then
    local main_resolution = tonumber(
        io.popen("xdpyinfo | grep dimensions | awk '{print $2}' | awk -Fx '{print $1}'"):read("*a")
    )
    if main_resolution == 3840 then
        config.font_size = 11.5
    elseif main_resolution == 1920 then
        config.font_size = 10
    else
        config.font_size = 9
    end
    config.default_prog = { "/usr/bin/fish" }
    config.window_decorations = "RESIZE"
end

return config
