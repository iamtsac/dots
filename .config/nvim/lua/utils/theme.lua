local M = {}

M.get_color = function(group, attr)
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    local color = hl[attr]
    if not color then
        return nil
    end
    return string.format("#%06x", color)
end

M.hl_overwrite = function(hls)
    for k, v in pairs(hls) do
        vim.api.nvim_set_hl(0, k, v)
    end
end

M.hl_markdown_code = function(c1, c2)
    local group = vim.api.nvim_create_augroup("MarkdownEvent", { clear = true })
    M.hl_overwrite({ RenderMarkdownCode = { bg = c1 } })

    vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        pattern = "markdown",
        callback = function()
            M.hl_overwrite({ RenderMarkdownCode = { bg = c2 } })
        end,
    })
    vim.api.nvim_create_autocmd("BufLeave", {
        group = group,
        pattern = "markdown",
        callback = function()
            M.hl_overwrite({ RenderMarkdownCode = { bg = c1 } })
        end,
    })
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

M.update_stylerc = function(theme, style)
    local path = vim.fn.expand("~/.config/stylerc")
    local lines = {}
    local f = io.open(path, "r")
    if f then
        for line in f:lines() do
            if not line:match("^theme=") and not line:match("^style=") then
                table.insert(lines, line)
            end
        end
        f:close()
    end
    table.insert(lines, "theme=" .. theme)
    table.insert(lines, "style=" .. style)
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
            -- Backups mapped strictly to the Neomodern Moon syntax palette
            local fallbacks = {
                [0] = { "Normal", "bg" }, -- black (M.base.black)
                [1] = { "Number", "fg" }, -- red (palette.number)
                [2] = { "String", "fg" }, -- green (palette.string)
                [3] = { "Constant", "fg" }, -- yellow (palette.constant)
                [4] = { "Keyword", "fg" }, -- blue (palette.keyword)
                [5] = { "Identifier", "fg" }, -- magenta (palette.property)
                [6] = { "Type", "fg" }, -- cyan (palette.type)
                [7] = { "Normal", "fg" }, -- white (palette.fg)

                [8] = { "Comment", "fg" }, -- bright_black (palette.comment)
                [9] = { "Number", "fg" }, -- bright_red
                [10] = { "String", "fg" }, -- bright_green
                [11] = { "Constant", "fg" }, -- bright_yellow
                [12] = { "Function", "fg" }, -- bright_blue (palette.func)
                [13] = { "Keyword", "fg" }, -- bright_magenta
                [14] = { "Operator", "fg" }, -- bright_cyan (palette.operator)
                [15] = { "Normal", "fg" }, -- bright_white
            }

            local group = fallbacks[i][1]
            local attr = fallbacks[i][2]
            color = M.get_color(group, attr) or c.foreground
        end

        c["color" .. i] = color
    end

    -- Ghostty Sync
    local ghostty_path = vim.fn.expand("~/.config/ghostty/themes/current_theme.lua")
    local theme_lines = { "local M = {}", "", "M." .. style .. " = {}" }
    for k, v in pairs(c) do
        if v and v ~= "" and v ~= "NONE" then
            table.insert(theme_lines, string.format('M.%s.%s = "%s"', style, k, v))
        end
    end
    table.insert(theme_lines, "\nreturn M")

    local f = io.open(ghostty_path, "w")
    if f then
        f:write(table.concat(theme_lines, "\n"))
        f:close()
    end

    -- Fish Sync
    local fish_path = vim.fn.expand("~/.config/fish/conf.d/theme.fish")
    local fish_f = io.open(fish_path, "w")
    if fish_f then
        fish_f:write("# Auto-generated Fish colors\n")
        local fish_map = {
            fish_color_normal = c.foreground,
            fish_color_command = c.color4,
            fish_color_quote = c.color2,
            fish_color_error = c.color1,
            fish_color_param = c.foreground,
            fish_color_comment = c.color8,
            fish_color_selection = "--background=" .. (c.selection_background:gsub("#", "") or ""),
        }
        for var, val in pairs(fish_map) do
            if val then
                local clean_val = val:gsub("#", "")
                fish_f:write(string.format("set -g %s %s\n", var, clean_val))
            end
        end
        fish_f:close()
    end

    -- Execute config script if it exists
    local config_script = vim.fn.expand("~/.config/ghostty/config.lua")
    if vim.fn.filereadable(config_script) == 1 then
        os.execute("lua " .. config_script)
    end
end

M.load_theme = function()
    local args = M.read_args(os.getenv("HOME") .. "/.config/stylerc")
    local theme_name = args.theme
    local style = args.style
    if not theme_name then
        vim.notify("No theme defined in ~/.config/stylerc", vim.log.levels.WARN)
        return
    end
    local ok, theme_module = pcall(require, "themes." .. theme_name)
    if ok then
        theme_module.setup(style, M)
    else
        vim.notify("Could not load theme: " .. theme_name, vim.log.levels.ERROR)
    end
end

return M
