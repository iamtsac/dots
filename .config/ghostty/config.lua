local os = require("os")
local config = {}
local theme = {}

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if string.find(io.popen("uname"):read("*a"), "Darwin") then
    local main_resolution = tonumber(
        io.popen("system_profiler SPDisplaysDataType | grep Resolution | awk '{print $2}' | head -n 1"):read("*a")
    )
    config.command = "/opt/homebrew/bin/fish"
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
    config.command = "/usr/bin/fish"
    if main_resolution == 3840 then
        config.font_size = 13
    elseif main_resolution == 1920 then
        config.font_size = 10
    else
        config.font_size = 10
    end
end

config.font_family = "JetBrains Mono"
config.font_style = "SemiBold"
config.font_feature = "feat on"
config.freetype_load_flags = "true"

config.window_decoration = "none"
config.window_theme = "ghostty"
config.window_vsync = "false"
config.copy_on_select = "false"
config.shell_integration_features = "true"
config.bold_is_bright = "false"
config.cursor_style_blink = "false"
config.app_notifications = "no-clipboard-copy"

config.keybind = {}
config.keybind.reload_config = "cmd+r"
config.keybind.new_tab = "cmd+t"
config.keybind.close_tab = "cmd+w"

-- config.theme = "Jellybeans"

theme.color0 = "#27272a"
theme.color1 = "#f5a191"
theme.color2 = "#90b99f"
theme.color3 = "#e6b99d"
theme.color4 = "#aca1cf"
theme.color5 = "#e29eca"
theme.color6 = "#ea83a5"
theme.color7 = "#c1c0d4"
theme.color8 = "#353539"
theme.color9 = "#ffae9f"
theme.color10 = "#9dc6ac"
theme.color11 = "#f0c5a9"
theme.color12 = "#b9aeda"
theme.color13 = "#ecaad6"
theme.color14 = "#f591b2"
theme.color15 = "#cac9dd"
theme.background = "#131314"
theme.foreground = "#c9c7cd"
theme.cursor_color = "#cac9dd"
theme.selection_background = "#2a2a2d"
theme.selection_foreground = "#c1c0d4"

ghostty_conf_file = io.open(os.getenv("HOME") .. "/.config/ghostty/config", "w")
io.output(ghostty_conf_file)
for k, v in pairs(config) do
    if k == "keybind" then
        for km, vm in pairs(v) do
            io.write(k .. " = " .. vm .. "=" .. km .. "\n")
        end
    else
        k = k:gsub("%_", "-")
        io.write(k .. " = " .. v .. "\n")
    end
end

if not config.theme then
    io.write("\n\n")
    for k, v in pairs(theme) do
        k = k:gsub("%_", "-")
        k = k:gsub("color", "palette = ")
        k = k:gsub("cursor.palette = ", "cursor-color")
        io.write(k .. "=" .. v .. "\n")
    end
end

io.close(ghostty_conf_file)

