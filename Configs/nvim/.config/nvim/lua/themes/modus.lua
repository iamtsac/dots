local M = {}

function M.setup(style, variant, utils)
    local c = {}
    vim.o.winborder = "rounded"
    vim.opt.background = style
    require("modus-themes").setup({
        style = "auto", variants = "default", transparent = false,
        dim_inactive = false, hide_inactive_statusline = false,
        line_nr_column_background = false, sign_column_background = false,
        styles = { comments = { italic = false }, keywords = { italic = false }, functions = {}, variables = {} },
        on_colors = function(colors) c = colors end,
    })
    
    vim.cmd("colorscheme modus")
    c.fg = utils.get_color("Normal", "fg")
    c.bg = utils.get_color("Normal", "bg")

    vim.schedule(function()
        if style == "dark" then
            c.bg_unselected = utils.color_changer.lighten(c.bg, 0.07)
            c.fg_unselected = utils.color_changer.darken(c.fg, 0.65)
            c.fg_selected = c.fg
            c.bg_selected = c.bg_unselected
            c.bg_tabbar = c.bg_unselected
            c.fg_indicator = utils.get_color("String", "fg")
            c.fg_border = c.bg_tabbar
            c.bg_dim = utils.color_changer.lighten(c.bg, 0.07)

            utils.hl_overwrite({
                SnacksImageMath = { fg = c.bg, bg = c.fg },
                SnacksPickerBorder = { fg = c.bg, bg = c.bg },
                SnacksPickerInput = { fg = c.fg, bg = c.bg_dim },
                SnacksPickerNormal = { fg = c.fg, bg = c.bg_dim },
                SnacksPickerMatch = { fg = utils.get_color("@comment.warning", "fg"), bg = "none" },
                SnacksPickerInputBorder = { fg = c.bg_dim, bg = c.bg_dim },
                SnacksPickerBoxBorder = { fg = c.bg_dim, bg = c.bg_dim },
                SnacksPickerTitle = { fg = c.bg_main, bg = c.red_faint },
                SnacksPickerBoxTitle = { fg = c.bg_main, bg = c.red_cooler },
                SnacksPickerListCursorLine = { link = "Boolean" },
                SnacksPickerList = { bg = c.bg_dim },
                SnacksPickerPrompt = { fg = c.red_cooler, bg = c.bg_dim },
                SnacksPickerPreviewTitle = { fg = c.bg, bg = c.red_cooler },
                SnacksPickerPreview = { bg = c.bg },
                SnacksPickerToggle = { bg = c.red_cooler, fg = c.bg },
                SnacksPickerDir = { fg = c.pink },
                SnacksPickerSelected = { link = "Type" },
                StatusLine = { fg = "none", bg = c.bg_tabbar },
                StatusLineNC = { fg = "none", bg = c.bg_tabbar },
                WinSeparator = { fg = c.fg_unselected, bg = "none" },
                Directory = { bg = "none" },
                BlinkCmpMenu = { link = "Normal" },
                BlinkCmpMenuBorder = { link = "Normal" },
                BlinkCmpLabelDetail = { link = "Type" },
                PmenuKind = { bg = "none" },
                PmenuExtra = { bg = "none" },
                NormalFloat = { bg = "none" },
                CursorLine = { bg = c.bg_dim },
                TreesitterContextSeparator = { link="Comment" },

                TabLineFill = { bg = c.bg_tabbar },
                TabLineSel = { bg = c.bg_selected, fg = c.fg_selected },
                TabLine = { bg = c.bg_unselected, fg = c.fg_unselected },
                TabLineIndicator = { bg = c.bg_tabbar, fg = c.fg_indicator },

                FloatingTabsActive = { fg = c.fg_selected, bg = c.bg_selected },
                FloatingTabsInactive = { fg = c.fg_unselected, bg = c.bg_unselected },
                FloatingTabsIndicator = { fg = c.fg_indicator, bg = c.bg_tabbar },
                FloatingTabsBorder = { fg = c.fg_border, bg = "NONE" },
                FloatingTabsSeparator = { fg = c.fg_indicator, bg = c.bg_tabbar },

                StatusLineMain = { fg = c.fg_main, italic = false },
                StatusLineSecondary = { fg = "#777777" },
            })
        end

        if style == "light" then

            c.bg_unselected = utils.color_changer.darken(c.bg, 0.07)
            c.fg_unselected = utils.color_changer.lighten(c.fg, 0.65)
            c.fg_selected = c.fg
            c.bg_selected = c.bg_unselected
            c.bg_tabbar = c.bg_unselected
            c.fg_indicator = utils.get_color("String", "fg")
            c.fg_border = c.bg_tabbar

            utils.hl_overwrite({
                SnacksImageMath = { fg = c.fg, bg = c.bg },
                SnacksPickerBorder = { fg = c.bg, bg = c.bg },
                SnacksPickerInput = { fg = c.fg, bg = c.bg_dim },
                SnacksPickerNormal = { fg = c.fg, bg = c.bg_dim },
                SnacksPickerMatch = { link = "@diff.minus" },
                SnacksPickerInputBorder = { fg = c.bg_dim, bg = c.bg_dim },
                SnacksPickerBoxBorder = { fg = c.bg_dim, bg = c.bg_dim },
                SnacksPickerTitle = { fg = c.bg, bg = c.bg_green_intense },
                SnacksPickerBoxTitle = { fg = c.fg, bg = c.bg_green_intense },
                SnacksPickerListCursorLine = { link = "Boolean" },
                SnacksPickerList = { bg = c.bg_dim },
                SnacksPickerPrompt = { fg = c.bg_red_intense, bg = c.bg_dim },
                SnacksPickerPreviewTitle = { fg = c.bg, bg = c.bg_red_intense },
                SnacksPickerPreview = { bg = c.bg },
                Directory = { bg = "none" },
                SnacksPickerToggle = { bg = c.bg_green_intense, fg = c.bg },
                SnacksPickerDir = { fg = c.bg_magenta_intense },
                SnacksPickerSelected = { link = "Type" },
                StatusLine = { fg = "none", bg = c.bg_tabbar },
                StatusLineNC = { fg = "none", bg = c.bg_tabbar },
                BlinkCmpMenu = { link = "Normal" },
                BlinkCmpMenuBorder = { link = "Normal" },
                BlinkCmpLabelDetail = { link = "Type" },
                WinSeparator = { fg = c.fg_unselected, bg = "none" },
                PmenuKind = { bg = "none" },
                PmenuExtra = { bg = "none" },
                NormalFloat = { bg = "none" },
                TreesitterContext = { link="Normal" },
                TreesitterContextLineNumber = { link="LineNr" },
                TreesitterContextSeparator = { link="Comment" },
                LineNr = { bg = "none" },
                DiffAdd = { link = "MiniDiffSignAdd" },
                DiffDelete = { link = "MiniDiffSignDelete" },
                DiffChange = { link = "MiniDiffSignChange" },

                TabLineFill = { bg = c.bg_tabbar },
                TabLineSel = { bg = c.bg_selected, fg = c.fg_selected },
                TabLine = { bg = c.bg_unselected, fg = c.fg_unselected },
                TabLineIndicator = { bg = c.bg_tabbar, fg = c.fg_indicator },

                FloatingTabsActive = { fg = c.fg_selected, bg = c.bg_selected },
                FloatingTabsInactive = { fg = c.fg_unselected, bg = c.bg_unselected },
                FloatingTabsIndicator = { fg = c.fg_indicator, bg = c.bg_tabbar },
                FloatingTabsBorder = { fg = c.fg_border, bg = "NONE" },
                FloatingTabsSeparator = { fg = c.fg_indicator, bg = c.bg_tabbar },

                StatusLineMain = { fg = c.fg_main, italic = false },
                StatusLineSecondary = { fg = "#777777" },
            })
        end
        -- utils.hl_markdown_code(c.bg_main, c.bg_alt)
    end)
end

return M
