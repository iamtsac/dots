local os = require("os")
local config = {}

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function custom_theme(name)
    return dofile(os.getenv("HOME") .. "/.config/ghostty/themes/" .. name .. ".lua")
end

if string.find(io.popen("uname"):read("*a"), "Darwin") then
    local main_resolution = tonumber(
        io.popen("system_profiler SPDisplaysDataType | grep Resolution | awk '{print $2}' | head -n 1"):read("*a")
    )
    config.shell = "/opt/homebrew/bin/fish"
    if main_resolution == 3840 then
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
        config.font_size = 16
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

config.term = "kitty"

config.font_family = "Iosevka Nerd Font"
config.bold_font = "auto"
config.italic_font = "auto"
config.bold_italic_font = "auto"
config.text_compositions_strategy = "platform"

config.remember_window_size = "yes"
config.hide_window_decorations = "yes"

config.kitty_mod = "super"
config.cursor_trail = 0

config.map = {}
config.map.load_config_file = "kitty_mod+r"
config.map.copy_to_clipboard = "ctrl+shift+c"
config.map.new_tab = "kitty_mod+t"
config.map.close_tab = "kitty_mod+w"
config.map.next_tab = "ctrl+tab"
config.map["change_font_size all +1"] = "ctrl+shift+equal"
config.map["change_font_size all -1"] = "ctrl+shift+minus"
config.map["change_font_size all 0"] = "ctrl+shift+0"


config.tab_bar_style = "fade"
config.tab_bar_edge = "top"
config.tab_separator  = " | "
config.tab_bar_align = "left"

config.tab_bar_background = "none"
config.active_tab_foreground = "#fff"
config.active_tab_background = "#222"
config.inactive_tab_foreground = "#555"
config.inactive_tab_background = "#000"
config.tab_fade = "1 1 1 1"

local theme = custom_theme("black_metal_gorgoroth")

kitty_conf_file = io.open(os.getenv("HOME") .. "/.config/kitty/kitty.conf", "w")
io.output(kitty_conf_file)
io.write("clear_all_shortcuts yes\n")
for k, v in pairs(config) do
    if k == "map" then
        for km, vm in pairs(v) do
            io.write(k .. " " .. vm .. " " .. km .. "\n")
        end
    else
        io.write(k .. " " .. v .. "\n")
    end
end

for k, v in pairs(theme) do
    io.write(k .. " " .. v .. "\n")
end
io.close(kitty_conf_file)

