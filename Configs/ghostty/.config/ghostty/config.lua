local os = require("os")
local io = require("io")

local function read_args(path)
    local args = {}
    local file = io.open(path, "r")
    if not file then return args end

    for l in file:lines() do
        local key, value = l:match("([^=]+)=(.+)")
        if key and value then
            args[key] = value:gsub("%s+", "")
        end
    end
    file:close()
    return args
end

local function get_output(cmd)
    local handle = io.popen(cmd)
    if not handle then return "" end
    local result = handle:read("*a")
    handle:close()
    return result or ""
end

local config = {}
local args = read_args(os.getenv("HOME") .. "/.config/stylerc")
args.style = args.style or "dark"
args.theme = args.theme or "default"

local uname = get_output("uname"):gsub("%s+", "")
local main_resolution = 0

if uname == "Darwin" then
    config.command = "/opt/homebrew/bin/fish"
    local raw_res = get_output("system_profiler SPDisplaysDataType | grep Resolution | awk '{print $2}' | head -n 1")
    main_resolution = tonumber(raw_res) or 0
elseif uname == "Linux" then
    config.command = "/usr/bin/fish"
    local cmd = "xrandr --current | grep -oE '[0-9]+x[0-9]+' | sort -rn | head -n 1"
    local raw_res = get_output(cmd)
    if raw_res == "" or raw_res == nil then 
        raw_res = "1920x1080"
    end
    main_resolution = string.gsub(raw_res, "%s+", "")
end

local default_config = { size = 14, style = (args.style == "light") and "Bold" or "Regular" }

local font_config_map = {
    ["3840x2160"] = { size = 18, style = (args.style == "light") and "SemiBold" or "Regular" },
    ["2560x1440"] = { size = 16, style = (args.style == "light") and "SemiBold" or "Regular" },
    ["1920x1200"] = { size = 13.5, style = "Medium"},
    ["1920x1080"] = { size = 13.5, style = "Medium" },
}

local selected_config = font_config_map[main_resolution] or default_config

config.font_size = selected_config.size
config.font_family = "Monaspace Neon Var"
config.font_style = selected_config.style
config.font_feature = "+feat, -calt"
config.font_shaping_break = "cursor"

config.window_decoration = true
config.gtk_titlebar = false
config.window_theme = "ghostty"
config.copy_on_select = false
config.shell_integration = "fish"
config.shell_integration_features = "ssh-env,ssh-terminfo,cursor,path"
config.cursor_style = "block"
config.cursor_style_blink = false
config.app_notifications = "no-clipboard-copy"
config.background_opacity = 1.0
config.clipboard_read = "allow"
config.clipboard_write = "allow"
config.clipboard_trim_trailing_spaces = true
config.macos_option_as_alt = true
config.window_new_tab_position = "end"
config.resize_overlay = "never"
config.gtk_tabs_location = "top"
config.palette_generate = true
config.palette_harmonious = false
config.split_preserve_zoom = true
config.unfocused_split_opacity = 0.5

-- REFACTORED: Keybinds as ordered arrays
local keybinds_global = {
    { "ctrl+shift+c", "copy_to_clipboard" },
    { "ctrl+shift+v", "paste_from_clipboard" },
    { "super+t", "new_tab" },
    { "super+w", "close_surface" },
    { "ctrl+tab", "next_tab" },
    { "ctrl+shift+tab", "previous_tab" },
    { "ctrl+shift+right", "move_tab:1" },
    { "ctrl+shift+left", "move_tab:-1" },
    { "super+n", "new_window" },
    { "ctrl+shift+space", "toggle_command_palette" },
    { "ctrl+shift+equal", "increase_font_size:0.5" },
    { "ctrl+shift+minus", "decrease_font_size:0.5" },
    { "ctrl+shift+0", "reset_font_size" },
    { "super+r", "reload_config" },
    { "ctrl+b", "activate_key_table_once:mux" },
}

local keybinds_mux = {
    { "c", "new_tab" },
    { "x", "close_surface" },
    { "n", "next_tab" },
    { "p", "previous_tab" },
    { "a", "last_tab" },
    { "ctrl+shift+p", "move_tab:-1" },
    { "ctrl+shift+n", "move_tab:1" },
    { "/", "start_search" },
    { "s", "toggle_tab_overview" },
    { "shift+3", "prompt_tab_title" },
    { "shift+semicolon", "toggle_command_palette" },
    { "o", "goto_split:next" },
    { "semicolon", "goto_split:next" },
    { "shift+5", "new_split:right" },
    { "shift+quote", "new_split:down" },
    { "z", "toggle_split_zoom" },
    { "h", "goto_split:left" },
    { "j", "goto_split:bottom" },
    { "k", "goto_split:top" },
    { "l", "goto_split:right" },
    { "u", "undo" },
    { "ctrl+r", "redo" },
    { "r", "activate_key_table:resize" },
    { "]", "activate_key_table:visual" },
    { "escape", "deactivate_key_table" },
    { "ctrl+[", "deactivate_key_table" },
}

-- Insert 1-9 into mux order
for i = 1, 9 do
    table.insert(keybinds_mux, { tostring(i), "goto_tab:" .. i })
end

local keybinds_resize = {
    { "h", "resize_split:left,10" },
    { "j", "resize_split:down,10" },
    { "k", "resize_split:up,10" },
    { "l", "resize_split:right,10" },
    { "=", "equalize_splits" },
    { "escape", "deactivate_key_table" },
    { "ctrl+[", "deactivate_key_table" },
    { "catch_all", "ignore" }
}

local keybinds_visual = {
    { "/", "start_search" },
    { "j", "scroll_page_lines:1" },
    { "k", "scroll_page_lines:-1" },
    { "ctrl+u", "scroll_page_up" },
    { "ctrl+d", "scroll_page_down" },
    { "shift+g", "scroll_to_bottom" },
    { "g>g", "scroll_to_top" },
    { "ctrl+n", "navigate_search:next" },
    { "ctrl+p", "navigate_search:previous" },
    { "escape", "deactivate_key_table" },
    { "ctrl+[", "deactivate_key_table" },
    { "catch_all", "ignore" }
}

local unbinds = { "ctrl+enter", "ctrl+shift+n", "ctrl+shift+p", "ctrl+shift+j"}

-- Theme Logic (Remains as dictionary)
local theme_path = string.format("%s/.config/ghostty/themes/current_theme.lua", os.getenv("HOME"))
local theme_ok, theme_data = pcall(dofile, theme_path)
local final_theme = {}

if theme_ok then
    local current_theme = theme_data[args.style] or {}
    for k, v in pairs(current_theme) do
        local palette_index = k:match("color(%d+)")
        if palette_index then
            table.insert(final_theme, { key = "palette", val = palette_index .. "=" .. v })
        elseif k == "foreground" or k == "background" or k == "selection_foreground" or k == "selection_background" then
            table.insert(final_theme, { key = k, val = v })
        elseif k == "cursor" then
            table.insert(final_theme, { key = "cursor-color", val = v })
        end
    end
end

-- Write to file
local out_file = io.open(os.getenv("HOME") .. "/.config/ghostty/config", "w")
if not out_file then error("Could not write to ghostty config") end

out_file:write("# Generated by config_gen.lua\n\n")

local function write_config_kv(k, v)
    local key = k:gsub("_", "-")
    if type(v) == "boolean" then
        out_file:write(key .. " = " .. (v and "true" or "false") .. "\n")
    elseif type(v) == "table" then
        for _, item in ipairs(v) do out_file:write(key .. " = " .. item .. "\n") end
    else
        out_file:write(key .. " = " .. v .. "\n")
    end
end

-- Write Config (Order not guaranteed here as requested)
for k, v in pairs(config) do
    write_config_kv(k, v)
end

out_file:write("\n# Keybindings\n")

local sections = {
    { data = keybinds_global, prefix = "" },
    { data = keybinds_mux,    prefix = "mux/" },
    { data = keybinds_resize, prefix = "resize/" },
    { data = keybinds_visual, prefix = "visual/" },
}

-- Handle all keybind tables in one loop
for _, section in ipairs(sections) do
    for _, b in ipairs(section.data) do
        out_file:write(string.format("keybind = %s%s=%s\n", section.prefix, b[1], b[2]))
    end
end

-- Handle unbinds (slightly different format, so kept separate)
for _, trigger in ipairs(unbinds) do
    out_file:write("keybind = " .. trigger .. "=unbind\n")
end

out_file:write("\n# Theme\n")
for _, item in ipairs(final_theme) do
    out_file:write(string.format("%s = %s\n", item.key:gsub("_", "-"), item.val))
end

out_file:write("\n# Theme\n")
for _, item in ipairs(final_theme) do
    local key = item.key:gsub("_", "-")
    out_file:write(key .. " = " .. item.val .. "\n")
end

out_file:close()
