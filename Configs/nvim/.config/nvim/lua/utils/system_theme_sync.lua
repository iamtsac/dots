local M = {}

M.sync_ghostty = function(style, c)
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
end

M.sync_yazi = function(c, get_color_fn)
    local hl = {
        tab_sel_bg    = get_color_fn("TabLineSel", "bg") or c.background,
        tab_sel_fg    = get_color_fn("TabLineSel", "fg") or c.foreground,
        tab_bg        = get_color_fn("TabLine", "bg") or c.background,
        tab_fg        = get_color_fn("TabLine", "fg") or c.color8,
        status_bg     = get_color_fn("StatusLine", "bg") or c.background,
        status_fg     = get_color_fn("StatusLine", "fg") or c.foreground,
        separator     = get_color_fn("WinSeparator", "fg") or c.color8,
        dir           = get_color_fn("Directory", "fg") or c.color4,
        msg_err       = get_color_fn("DiagnosticError", "fg") or c.color1,
        msg_warn      = get_color_fn("DiagnosticWarn", "fg") or c.color3,
        msg_info      = get_color_fn("DiagnosticInfo", "fg") or c.color6,
        git_add       = get_color_fn("DiffAdd", "fg") or c.color2,
        git_change    = get_color_fn("DiffChange", "fg") or c.color3,
    }

    local yazi_conf = {
        manager = {
            border_style = { fg = hl.separator },
            hovered      = { fg = hl.tab_sel_fg, bg = hl.tab_bg },
        },
        tabs = {
            active   = { fg = hl.tab_sel_fg, bg = hl.tab_sel_bg, bold = true },
            inactive = { fg = hl.tab_fg, bg = hl.tab_bg },
        },
        mode = {
            normal_main = { fg = c.background, bg = c.color4, bold = true },
            normal_alt  = { fg = c.foreground, bg = hl.tab_bg },
            select_main = { fg = c.background, bg = c.color2, bold = true },
            select_alt  = { fg = c.foreground, bg = hl.tab_bg },
            unset_main  = { fg = c.background, bg = c.color1, bold = true },
            unset_alt   = { fg = c.foreground, bg = hl.tab_bg },
        },
        status = {
            separator_background = hl.status_bg,
            separator_foreground = hl.status_fg,
            progress_label       = { fg = c.foreground, bg = hl.tab_bg, bold = true },
            progress_total       = { fg = c.color8, bg = hl.status_bg },
            permissions          = { fg = c.color2 },
        },
        input = {
            border   = { fg = hl.tab_sel_bg },
            title    = { fg = hl.tab_sel_fg },
            value    = { fg = c.foreground },
            selected = { bg = c.selection_background },
        },
        select = {
            border   = { fg = hl.tab_sel_bg },
            active   = { fg = c.color5, bold = true },
            inactive = { fg = c.foreground },
        },
        completion = {
            border   = { fg = hl.tab_sel_bg },
            active   = { fg = c.color6, bg = hl.tab_bg },
            inactive = { fg = c.foreground },
        },
        tasks = {
            border   = { fg = hl.tab_sel_bg },
            title    = { fg = hl.tab_sel_fg },
            hovered  = { fg = hl.tab_sel_fg, bg = hl.tab_bg },
        },
        which = {
            mask     = { bg = c.background },
            cand     = { fg = c.color6 },
            rest     = { fg = c.color8 },
            desc     = { fg = c.color5 },
        },
        notify = {
            title_info  = { fg = hl.msg_info },
            title_warn  = { hl.msg_warn },
            title_error = { hl.msg_err },
        },
        filetype = {
            rules = {
                { url = "*/", fg = hl.dir, bold = true },
            }
        }
    }

    local toml_output = { "# Auto-generated Yazi Theme via Structured Neovim highlights" }

    local function serialize_style(style_table)
        local props = {}
        if style_table.fg then table.insert(props, string.format('fg = "%s"', style_table.fg)) end
        if style_table.bg then table.insert(props, string.format('bg = "%s"', style_table.bg)) end
        if style_table.bold then table.insert(props, "bold = true") end
        return "{ " .. table.concat(props, ", ") .. " }"
    end

    for section, blocks in pairs(yazi_conf) do
        if section ~= "filetype" then
            table.insert(toml_output, string.format("\n[%s]", section))
            for key, val in pairs(blocks) do
                if type(val) == "table" then
                    table.insert(toml_output, string.format("%s = %s", key, serialize_style(val)))
                else
                    table.insert(toml_output, string.format('%s = "%s"', key, val))
                end
            end
        end
    end

    table.insert(toml_output, "\n[filetype]\nrules = [")
    for _, rule in ipairs(yazi_conf.filetype.rules) do
        local props = { string.format('url = "%s"', rule.url) }
        if rule.fg then table.insert(props, string.format('fg = "%s"', rule.fg)) end
        if rule.bold then table.insert(props, "bold = true") end
        table.insert(toml_output, "    { " .. table.concat(props, ", ") .. " },")
    end
    table.insert(toml_output, "]")

    local yazi_path = vim.fn.expand("~/.config/yazi/theme.toml")
    local yf = io.open(yazi_path, "w")
    if yf then
        yf:write(table.concat(toml_output, "\n") .. "\n")
        yf:close()
    end
end

return M
