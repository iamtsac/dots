local M = {}

function M.setup(style, variant, utils)
    vim.o.winborder = "rounded"
    vim.opt.background = style
    local theme, pallete = require("kanso").setup({
        bold = true, italics = false, compile = false, undercurl = true,
        commentStyle = { italic = true }, functionStyle = {}, keywordStyle = { italic = false },
        statementStyle = {}, typeStyle = {}, transparent = false, dimInactive = false,
        terminalColors = true,
        background = { dark = variant, light = variant },
    })

    vim.cmd("colorscheme kanso")
    local c = {}
    vim.schedule(function()
        if style == "dark" then
            bg = utils.get_color("Normal", "bg")
            utils.hl_overwrite({ Normal = { bg = utils.color_changer.darken(utils.get_color("Normal", "bg"), 0.05)}})
            c.bg_dim = utils.color_changer.lighten(utils.get_color("Normal", "bg"), 0.03)
            c.fg = utils.get_color("Normal", "fg")
            c.bg = utils.get_color("Normal", "bg")
            c.red = utils.get_color("Error", "fg")
            c.green = utils.get_color("Character", "fg")
            c.orange = utils.get_color("Constant", "fg")
            utils.hl_overwrite({
                SnacksImageMath = { fg = c.bg, bg = c.fg },
                SnacksPickerBorder = { fg = c.bg, bg = c.bg },
                SnacksPickerInput = { fg = c.fg, bg = c.bg_dim },
                SnacksPickerNormal = { fg = c.fg, bg = c.bg_dim },
                SnacksPickerMatch = { fg = c.orange, bg = "none" },
                SnacksPickerInputBorder = { fg = c.bg_dim, bg = c.bg_dim },
                SnacksPickerBoxBorder = { fg = c.bg_dim, bg = c.bg_dim },
                SnacksPickerTitle = { fg = c.bg, bg = c.red },
                SnacksPickerBoxTitle = { fg = c.bg, bg = c.green },
                SnacksPickerListCursorLine = { link = "CursorLine" },
                SnacksPickerList = { bg = c.bg_dim },
                SnacksPickerPrompt = { fg = c.red, bg = c.bg_dim },
                SnacksPickerPreviewTitle = { fg = c.bg, bg = c.red },
                SnacksPickerPreview = { bg = c.bg },
                SnacksPickerTree = { bg = "none" },
                Directory = { bg = "none" },
                TreesitterContext = { link="CursorLine" },
                WhichKeyIcon = { link = "WhichKeyValue" },
                SnacksPickerToggle = { bg = c.red, fg = c.bg },
                SnacksPickerDir = { fg = c.green },
                SnacksPickerSelected = { link = "Type" },
                StatusLine = { fg = "none", bg = c.bg_dim },
                StatusLineNC = { fg = "none", bg = c.bg_dim },
                CursorLine = { bg = utils.color_changer.lighten(c.bg, 0.08) },
                TreesitterContext = { link="Normal" },
                TreesitterContextSeparator = { link="Comment" },
                TreesitterContextLineNumber = { link="LineNr" },
            })
            vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.fg, italic = false })
            vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = utils.color_changer.darken(c.fg, 0.30) })
            -- utils.hl_markdown_code(c.bg, c.bg_dim)
        end

        if style == "light" then
            c.bg_dim = utils.color_changer.darken(utils.get_color("Normal", "bg"), 0.03)
            c.fg = utils.get_color("Normal", "fg")
            c.bg = utils.get_color("Normal", "bg")
            c.red = utils.get_color("Error", "fg")
            c.green = utils.get_color("Character", "fg")
            c.orange = utils.get_color("Constant", "fg")
            c.violet = utils.get_color("@comment", "fg")
            utils.hl_overwrite({
                SnacksImageMath = { fg = c.fg, bg = c.bg },
                SnacksPickerBorder = { fg = c.bg, bg = c.bg },
                SnacksPickerInput = { fg = c.fg, bg = c.bg_dim },
                SnacksPickerNormal = { fg = c.fg, bg = c.bg_dim },
                SnacksPickerMatch = { link = "@diff.delta" },
                SnacksPickerInputBorder = { fg = c.bg_dim, bg = c.bg_dim },
                SnacksPickerBoxBorder = { fg = c.bg_dim, bg = c.bg_dim },
                SnacksPickerTitle = { bg = c.bg, fg = c.red },
                SnacksPickerBoxTitle = { bg = c.bg, fg = c.red },
                SnacksPickerListCursorLine = { fg = "none", bg = c.green },
                SnacksPickerList = { bg = c.bg_dim },
                SnacksPickerPrompt = { fg = c.violet, bg = c.bg_dim },
                SnacksPickerPreviewTitle = { fg = c.bg, bg = c.red },
                SnacksPickerPreview = { bg = c.bg },
                SnacksPickerToggle = { bg = c.green, fg = c.bg },
                SnacksPickerDir = { fg = c.orange },
                SnacksPickerTree = { bg = "none" },
                SnacksPickerSelected = { link = "Number" },
                Directory = { bg = "none" },
                StatusLine = { fg = "none", bg = c.bg_dim },
                StatusLineNC = { fg = "none", bg = c.bg_dim },
                BlinkCmpMenu = { link = "Normal" },
                BlinkCmpMenuBorder = { link = "Normal" },
                BlinkCmpLabelDetail = { link = "Type" },
                PmenuKind = { bg = "none" },
                PmenuExtra = { bg = "none" },
                LineNr = { bg = "none" },
                NormalFloat = { bg = "none" },
                CursorLine = { bg = c.bg_dim },
                TreesitterContext = { link="Normal" },
                TreesitterContextLineNumber = { link="LineNr" },
                TreesitterContextSeparator = { link="Comment" },
                WhichKeyIcon = { link = "WhichKeyValue" },
            })

            vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.fg, italic = false })
            vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = utils.color_changer.lighten(c.fg, 0.30) })
        end
    end)
end
return M
