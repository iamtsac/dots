local os = require("os")
local config = {}

function custom_theme(name)
    return dofile(os.getenv("HOME") .. "/.config/ghostty/themes/" .. name .. ".lua")
end

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
        config.font_size = 12
    else
        config.font_size = 10
    end
end

config.font_family = "JetBrainsMono Nerd Font"
config.font_style = "Regular"
config.font_feature = "-calt, -liga, -dliga"
config.freetype_load_flags = "true"

config.window_decoration = "none"
config.window_theme = "ghostty"
config.window_vsync = "false"
config.copy_on_select = "false"
config.shell_integration_features = "true"
config.bold_is_bright = "true"
config.cursor_style_blink = "false"
config.app_notifications = "no-clipboard-copy"

config.keybind = {}
config.keybind.reload_config = "cmd+r"
config.keybind.new_tab = "cmd+t"
config.keybind.close_tab = "cmd+w"
config.keybind.unbind = {"ctrl+enter"}

-- config.theme = "Jellybeans"
local theme = custom_theme("black_metal_gorgoroth")
-- theme.background = "#050505"
-- theme.foreground = "#DDDDDD"

ghostty_conf_file = io.open(os.getenv("HOME") .. "/.config/ghostty/config", "w")
io.output(ghostty_conf_file)
for k, v in pairs(config) do
    if k == "keybind" then
        for km, vm in pairs(v) do
            if km == "unbind" then
                for i=1,#vm do
                    io.write(k .. " = " .. vm[i] .. "=unbind" .. "\n")
                end
            else
                io.write(k .. " = " .. vm .. "=" .. km .. "\n")
            end
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

