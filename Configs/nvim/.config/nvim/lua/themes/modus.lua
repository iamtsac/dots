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
            c.string = utils.get_color("String", "fg")
            c.bg_unselected = utils.color_changer.lighten(c.bg, 0.15)
            c.fg_unselected = utils.color_changer.darken(c.fg, 0.45)

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
                SnacksPickerListCursorLine = { fg = "none", bg = c.blue_warmer },
                SnacksPickerList = { bg = c.bg_dim },
                SnacksPickerPrompt = { fg = c.red_cooler, bg = c.bg_dim },
                SnacksPickerPreviewTitle = { fg = c.bg, bg = c.red_cooler },
                SnacksPickerPreview = { bg = c.bg },
                SnacksPickerToggle = { bg = c.red_cooler, fg = c.bg },
                SnacksPickerDir = { fg = c.pink },
                SnacksPickerSelected = { link = "Type" },
                StatusLine = { fg = "none", bg = c.bg_dim },
                Directory = { bg = "none" },
                StatusLineNC = { fg = "none", bg = c.bg_dim },
                BlinkCmpMenu = { link = "Normal" },
                BlinkCmpMenuBorder = { link = "Normal" },
                BlinkCmpLabelDetail = { link = "Type" },
                PmenuKind = { bg = "none" },
                PmenuExtra = { bg = "none" },
                NormalFloat = { bg = "none" },
                CursorLine = { bg = c.bg_dim },
                TreesitterContextBottom = { underline=true },
                TreesitterContextLineNumberBottom = { underline=true },
                TreesitterContextSeparator = { link="Comment" },

                TabLineFill = { bg = c.bg_unselected },
                TabLineSel = { bg = c.bg, fg = utils.get_color("Character", "fg") },
                TabLine = { bg = c.bg_unselected, fg = c.fg_unselected },
                TabLineIndicator = { bg = c.bg, fg = c.string },
            })
            vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.fg_main, italic = false })
            vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#777777" })
        end

        if style == "light" then

            c.string = utils.get_color("String", "fg")
            c.bg_unselected = utils.color_changer.darken(c.bg, 0.17)
            c.fg_unselected = utils.color_changer.lighten(c.fg, 0.45)

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
                SnacksPickerListCursorLine = { fg = "none", bg = c.bg_yellow_nuanced },
                SnacksPickerList = { bg = c.bg_dim },
                SnacksPickerPrompt = { fg = c.bg_red_intense, bg = c.bg_dim },
                SnacksPickerPreviewTitle = { fg = c.bg, bg = c.bg_red_intense },
                SnacksPickerPreview = { bg = c.bg },
                Directory = { bg = "none" },
                SnacksPickerToggle = { bg = c.bg_green_intense, fg = c.bg },
                SnacksPickerDir = { fg = c.bg_magenta_intense },
                SnacksPickerSelected = { link = "Type" },
                StatusLine = { fg = "none", bg = c.bg_dim },
                StatusLineNC = { fg = "none", bg = c.bg_dim },
                BlinkCmpMenu = { link = "Normal" },
                BlinkCmpMenuBorder = { link = "Normal" },
                BlinkCmpLabelDetail = { link = "Type" },
                PmenuKind = { bg = "none" },
                PmenuExtra = { bg = "none" },
                NormalFloat = { bg = "none" },
                TreesitterContext = { link="Normal" },
                TreesitterContextLineNumber = { link="LineNr" },
                TreesitterContextSeparator = { link="Comment" },
                LineNr = { bg = "none" },
                TabLineFill = { bg = c.bg_unselected },
                TabLineSel = { bg = c.bg, fg = utils.get_color("@lsp.type.variable", "fg") },
                TabLine = { bg = c.bg_unselected, fg = c.fg_unselected },
                TabLineIndicator = { bg = c.bg, fg = c.string },
            })
            vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.fg_main, italic = false })
            vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#777777" })
        end
        -- utils.hl_markdown_code(c.bg_main, c.bg_alt)
    end)
end

return M
