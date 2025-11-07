local os = require("os")
local config = {}

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function custom_theme(name)
    return dofile(os.getenv("HOME") .. "/.config/kitty/themes/" .. name .. ".lua")
end

local function read_args(path)
    file = io.open(path, "r")
    args = {}
    for l in file:lines() do
        content = {}
        for m in l:gmatch("([^=]+)=?") do
            table.insert(content, m)
        end
        args[content[1]] = content[2]
    end
    return args
end
args = read_args(os.getenv("HOME") .. "/.config/stylerc")

local main_resolution = nil
if string.find(io.popen("uname"):read("*a"), "Darwin") then
    config.shell = "/opt/homebrew/bin/fish"
    main_resolution = io.popen("system_profiler SPDisplaysDataType | grep Resolution | awk '{print $2}' | head -n 1"):read("*a")

elseif string.find(io.popen("uname"):read("*a"), "Linux") then
    config.shell = "/usr/bin/fish"
    main_resolution = io.popen("xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1"):read("*a")
    -- io.popen("xdpyinfo | grep dimensions | awk '{print $2}' | awk -Fx '{print $1}'"):read("*a")
end

local max_res = 0
for v in string.gmatch(main_resolution, "[^%s]+") do
    max_res = math.max(tonumber(v), max_res)
end
main_resolution = max_res
if main_resolution == 3840 then
    config.font_size = 14
elseif main_resolution == 2560 then
    config.font_size = 12
elseif main_resolution == 1920 then
    config.font_size = 12
else
    config.font_size = 10
end

if not file_exists(os.getenv("HOME") .. "/.terminfo/x/xterm-kitty") then
    os.execute( "tempfile=$(mktemp) && curl -o $tempfile https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/x/xterm-kitty && tic -x -o ~/.terminfo $tempfile && rm $tempfile")
end

config.term = "xterm-kitty"

font_weight = "SemiBold"
if args.style == "light" then
    font_weight = "Bold"
end
config.font_family = [[ family="Iosevka Nerd Font" style=]] .. font_weight
config.bold_font = "auto"
config.italic_font = "auto"
config.bold_italic_font = "auto"

config.remember_window_size = "yes"
config.hide_window_decorations = "yes"
config.window_margin_width = 2

config.kitty_mod = "super"
config.cursor_trail = 0

config.map = {}
config.map.copy_to_clipboard = "ctrl+shift+c"
config.map.paste_from_clipboard = "ctrl+shift+v"
config.map.new_tab = "kitty_mod+t"
config.map.close_tab = "kitty_mod+w"
config.map.next_tab = "ctrl+tab"
config.map.new_os_window = "kitty_mod+n"
config.map["change_font_size all +1.0"] = "ctrl+shift+equal"
config.map["change_font_size all -1.0"] = "ctrl+shift+minus"
config.map["change_font_size all 0"] = "ctrl+shift+0"
-- config.map[ [[combine : launch --type=overlay bash -c "lua $HOME/.config/kitty/config.lua" : load_config_file]] ] = "kitty_mod+r"
config.map[ [[load_config_file]] ]= "kitty_mod+r"

config.adjust_line_height = "100%"
config.adjust_column_width = "100%"

config.tab_bar_style = "fade"
config.tab_bar_edge = "top"
config.tab_separator  = " | "
config.tab_bar_align = "left"

config.tab_bar_background = "none"
config.tab_fade = "1 1 1 1"

local theme = custom_theme(args.theme)[args.style]
config.active_tab_font_style = "bold"

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
