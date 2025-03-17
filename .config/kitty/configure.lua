local os = require("os")
local config = {}

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if string.find(io.popen("uname"):read("*a"), "Darwin") then
    local main_resolution = tonumber(
        io.popen("system_profiler SPDisplaysDataType | grep Resolution | awk '{print $2}' | head -n 1"):read("*a")
    )
    config.shell = "/opt/homebrew/bin/fish"
    if main_resolution > 3000 then
        config.font_size = 16
    elseif main_resolution == 1920 then
        config.font_size = 13
    else
        config.font_size = 9
    end

elseif string.find(io.popen("uname"):read("*a"), "Linux") then
    local main_resolution = tonumber(
        io.popen("xdpyinfo | grep dimensions | awk '{print $2}' | awk -Fx '{print $1}'"):read("*a")
    )
    if main_resolution == 3840 then
        config.font_size = 10
    elseif main_resolution == 1920 then
        config.font_size = 10
    else
        config.font_size = 10
    end
    config.shell = "/usr/bin/fish"
end

if not file_exists(os.getenv("HOME") .. "/.terminfo/x/xterm-kitty") then
    os.execute( "tempfile=$(mktemp) && curl -o $tempfile https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/x/xterm-kitty && tic -x -o ~/.terminfo $tempfile && rm $tempfile")
end

config.term = "xterm-kitty"

config.font_family = "family='Iosevka Nerd Font'"
config.bold_font = "auto"
config.italic_font = "auto"
config.bold_italic_font = "auto"

config.remember_window_size = "yes"
config.hide_window_decorations = "yes"
config.map = "kitty_mod+f5 load_config_file"
config.kitty_mod = "super"

config.tab_bar_style = "powerline"
config.tab_bar_edge = "top"

config.background = "#131314"
config.foreground = "#c9c7cd"
config.selection_foreground = "#c1c0d4"
config.selection_background = "#2a2a2d"
config.color0 = "#27272a"
config.color1 = "#f5a191"
config.color2 = "#90b99f"
config.color3 = "#e6b99d"
config.color4 = "#aca1cf"
config.color5 = "#e29eca"
config.color6 = "#ea83a5"
config.color7 = "#c1c0d4"
config.color8 = "#353539"
config.color9 = "#ffae9f"
config.color10 = "#9dc6ac"
config.color11 = "#f0c5a9"
config.color12 = "#b9aeda"
config.color13 = "#ecaad6"
config.color14 = "#f591b2"
config.color15 = "#cac9dd"

kitty_conf_file = io.open(os.getenv("HOME") .. "/.config/kitty/kitty.conf", "w")
io.output(kitty_conf_file)
for k, v in pairs(config) do
    io.write(k .. " " .. v .. "\n")
end
io.close(kitty_conf_file)

