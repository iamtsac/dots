local M = {}

function M.setup(style, variant, utils)
    vim.o.winborder = "rounded"
    vim.opt.background = style
    local koda = require("koda")
    koda.setup({
        transparent = false,
        auto = true,
        cache = true,
        styles = { functions = { bold = true }, keywords = {}, comments = {}, strings = {}, constants = {} },
        colors = {
            bg = "#101010",
            fg = "#b0b0b0",
            dim = "#000000",
            line = "#272727",
            keyword = "#777777",
            comment = "#50585d",
            border = "#ffffff",
            emphasis = "#ffffff",
            func = "#ffffff",
            string = "#ffffff",
            char = "#ffffff",
            const = "#d9ba73",
            highlight = "#458ee6",
            info = "#8ebeec",
            success = "#86cd82",
            warning = "#d9ba73",
            danger = "#ff7676",
            green = "#14ba19",
            orange = "#f54d27",
            red = "#701516",
            pink = "#f2a4db",
            cyan = "#5abfb5",
        },
    })

    vim.cmd("colorscheme koda")
    vim.schedule(function()
        local c = koda.get_palette()
        c.pickerbg = utils.color_changer.lighten(c.bg, 0.03)

        c.bg_unselected = utils.color_changer.lighten(c.bg, 0.04)
        c.fg_unselected = utils.color_changer.darken(c.fg, 0.65)
        c.fg_selected = c.fg
        c.bg_selected = c.bg_unselected
        c.bg_tabbar = c.bg_unselected
        c.fg_indicator = utils.get_color("Constant", "fg")
        c.fg_border = c.bg_tabbar

        if style == "dark" then
            utils.hl_overwrite({
                SnacksImageMath = { fg = c.emphasis, bg = c.bg },
                SnacksPickerBorder = { fg = c.bg, bg = c.bg },
                SnacksPickerInput = { fg = c.fg, bg = c.pickerbg },
                SnacksPickerNormal = { fg = c.fg, bg = c.pickerbg },
                SnacksPickerMatch = { fg = utils.get_color("@comment.warning", "fg"), bg = "none" },
                SnacksPickerInputBorder = { fg = c.pickerbg, bg = c.pickerbg },
                NormalFloat = { bg = "none" },
                LineNr = { bg = "none" },
                Directory = { bg = "none" },
                SnacksPickerBoxBorder = { fg = c.pickerbg, bg = c.pickerbg },
                SnacksPickerTitle = { fg = c.bg, bg = c.orange },
                SnacksPickerBoxTitle = { fg = c.bg, bg = c.green },
                SnacksPickerListCursorLine = { fg = "none", bg = c.line },
                SnacksPickerList = { bg = c.pickerbg, fg = c.emphasis },
                SnacksPickerPrompt = { fg = c.func, bg = c.pickerbg },
                SnacksPickerPreviewTitle = { fg = c.bg, bg = c.func },
                SnacksPickerPreview = { bg = c.bg },
                SnacksPickerToggle = { bg = c.func, fg = c.bg },
                SnacksPickerDir = { fg = c.fg },
                SnacksPickerSelected = { link = "Type" },
                -- StatusLine = { fg = "none", bg = c.bg_tabbar },
                -- StatusLineNC = { fg = "none", bg = c.bg_tabbar },
                CursorLine = { bg = c.pickerbg },
                WinSeparator = { fg = c.fg_unselected, bg = "none" },
                TreesitterContext = { link = "Normal" },
                TreesitterContextLineNumber = { link = "LineNr" },
                TreesitterContextSeparator = { link = "Comment" },
                -- RenderMarkdownCode = { bg = c.bg },
                TabLineFill = { bg = c.bg_tabbar },
                TabLineSel = { bg = c.bg_selected, fg = c.fg_selected },
                TabLine = { bg = c.bg_unselected, fg = c.fg_unselected },
                TabLineIndicator = { bg = c.bg_tabbar, fg = c.fg_indicator },

                FloatingTabsActive = { fg = c.fg_selected, bg = c.bg_selected },
                FloatingTabsInactive = { fg = c.fg_unselected, bg = c.bg_unselected },
                FloatingTabsIndicator = { fg = c.fg_indicator, bg = c.bg_tabbar },
                FloatingTabsBorder = { fg = c.fg_border, bg = "NONE" },
                FloatingTabsSeparator = { fg = c.fg_indicator, bg = c.bg_tabbar },

                -- StatusLineMain = { fg = c.fg, italic = false },
                -- StatusLineSecondary = { fg = "#777777" },
            })
            -- utils.hl_markdown_code(c.bg, c.dim)
        end
    end)
end

return M
