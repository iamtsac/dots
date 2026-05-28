local M = {}

M.color_changer = {}
local WHITE = "#FFFFFF"
local BLACK = "#000000"

local function hexToRgb(color)
    local hex = "[abcdef0-9][abcdef0-9]"
    local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
    color = string.lower(color)

    assert(string.find(color, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(color))

    local r, g, b = string.match(color, pat)
    return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

function M.color_changer.blend(a, coeff, b)
    local A = hexToRgb(a)
    local B = hexToRgb(b)
    local alpha = math.abs(coeff)

    local blendChannel = function(i)
        local ret = ((1 - alpha) * B[i] + alpha * A[i])
        return math.floor(math.min(math.max(0, ret), 255) + 0.5)
    end

    return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end

function M.color_changer.lighten(a, coeff)
    return M.color_changer.blend(WHITE, coeff, a)
end

function M.color_changer.darken(a, coeff)
    return M.color_changer.blend(BLACK, coeff, a)
end

M.get_color = function(group, attr)
    local hl = vim.api.nvim_get_hl(0, { name = group, link = true })
    local color = hl[attr]
    if not color then
        return nil
    end
    return string.format("#%06x", color)
end

M.hl_overwrite = function(hls)
    for k, v in pairs(hls) do
        local hl = vim.api.nvim_get_hl(0, { name = k, link = false })
        for attr, color in pairs(v) do
            hl[attr] = color
        end
        vim.api.nvim_set_hl(0, k, hl)
    end
end

M.read_args = function(path)
    local file = io.open(path, "r")
    if not file then
        return {}
    end
    local args = {}
    for l in file:lines() do
        local content = {}
        for m in l:gmatch("([^=]+)=?") do
            table.insert(content, m)
        end
        if content[1] then
            args[content[1]] = content[2]
        end
    end
    file:close()
    return args
end

M.update_stylerc = function(theme, style, variant)
    local path = vim.fn.expand("~/.config/stylerc")
    local lines = {}
    local f = io.open(path, "r")
    if f then
        for line in f:lines() do
            if not line:match("^theme=") and not line:match("^style=") and not line:match("^variant=") then
                table.insert(lines, line)
            end
        end
        f:close()
    end
    table.insert(lines, "theme=" .. theme)
    table.insert(lines, "style=" .. style)
    table.insert(lines, "variant=" .. variant)
    local out = io.open(path, "w")
    if out then
        out:write(table.concat(lines, "\n") .. "\n")
        out:close()
    end
end

M.sync_system_theme = function()
    local style = vim.o.background
    local bg = M.get_color("Normal", "bg")

    if not bg or bg == "" or bg == "NONE" then
        M.get_color("BGIfNotTransparent", "bg")
        if not bg or bg == "" or bg == "NONE" then
            bg = (style == "dark") and "#000000" or "#EEEEEE"
        end
    end

    local c = {
        background = bg,
        foreground = M.get_color("Normal", "fg"),
        cursor = M.get_color("Cursor", "bg") or M.get_color("Normal", "fg"),
        selection_background = M.get_color("Visual", "bg"),
        selection_foreground = M.get_color("Visual", "fg"),
    }

    for i = 0, 15 do
        local var = "terminal_color_" .. i
        local color = vim.g[var]

        if not color or color == "" or color == "NONE" then
            local fallbacks = {
                [0] = { "Normal", "bg" },
                [1] = { "Number", "fg" },
                [2] = { "String", "fg" },
                [3] = { "Constant", "fg" },
                [4] = { "Keyword", "fg" },
                [5] = { "Identifier", "fg" },
                [6] = { "Type", "fg" },
                [7] = { "Normal", "fg" },

                [8] = { "Comment", "fg" },
                [9] = { "Number", "fg" },
                [10] = { "String", "fg" },
                [11] = { "Constant", "fg" },
                [12] = { "Function", "fg" },
                [13] = { "Keyword", "fg" },
                [14] = { "Operator", "fg" },
                [15] = { "Normal", "fg" },
            }

            local group = fallbacks[i][1]
            local attr = fallbacks[i][2]
            color = M.get_color(group, attr) or c.foreground
        end

        c["color" .. i] = color
    end

    local sync_tools = require("utils.system_theme_sync")
    sync_tools.sync_ghostty(style, c)
    sync_tools.sync_yazi(c, M.get_color)

    -- Execute config script if it exists
    local config_script = vim.fn.expand("~/.config/ghostty/config.lua")
    if vim.fn.filereadable(config_script) == 1 then
        os.execute("lua " .. config_script)
    end
end

M.load_theme = function()
    for i = 0, 15 do
        vim.g["terminal_color_" .. i] = nil
    end

    local stylerc_path = os.getenv("HOME") .. "/.config/stylerc"
    local args = M.read_args(stylerc_path)
    local theme_name = args.theme
    if not theme_name then
        return
    end

    package.loaded["themes." .. theme_name] = nil

    local ok, theme_module = pcall(require, "themes." .. theme_name)
    if ok then
        vim.cmd("highlight clear")
        if vim.fn.exists("syntax_on") then
            vim.cmd("syntax reset")
        end

        theme_module.setup(args.style, args.variant, M)
        vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
        vim.opt.termguicolors = true
        require("themes.generic_style").apply()

        vim.schedule(function()
            local cursor_color = M.get_color("Cursor", "bg") or M.get_color("Normal", "fg")
            if cursor_color and cursor_color:match("^#") then
                -- Send OSC 12 (Change Cursor Color) escape code
                -- \27]12; sets the cursor color, \27\\ terminates the string sequence cleanly
                io.write(string.format("\27]12;%s\27\\", cursor_color))
                io.flush()
            end
        end)
    else
        vim.notify("Theme Refresh Failed: " .. theme_name, vim.log.levels.ERROR)
    end
end

return M
