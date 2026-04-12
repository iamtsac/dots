local M = {}

function M.setup(style, variant, utils)

    vim.o.winborder = "rounded"
    vim.opt.background = style

    require("neomodern").setup({
        bg = "default",
        theme = variant, -- 'moon' | 'iceclimber' | 'gyokuro' | 'hojicha' | 'roseprime'
        gutter = {
            cursorline = false,
            dark = false,
        },
        diagnostics = {
            darker = false,
            undercurl = true,
            background = true,
        },
    })

    require("neomodern").load()

    vim.schedule(function()
        local c = {}
        if style == "dark" then
            c.alt = utils.color_changer.lighten(utils.get_color("Normal", "bg"), 0.015)
            c.line = utils.color_changer.lighten(utils.get_color("CursorLine", "bg"), 0.03)
            vim.api.nvim_set_hl(0, "StatusLineMain", { fg = utils.get_color("Normal", "fg"), italic = false })
            vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = utils.color_changer.lighten(utils.get_color("Normal", "bg"), 0.40) })
        elseif style == "light" then
            c.alt = utils.color_changer.darken(utils.get_color("Normal", "bg"), 0.05)
            c.line = utils.color_changer.darken(utils.get_color("CursorLine", "bg"), 0.08)
            vim.api.nvim_set_hl(0, "StatusLineMain", { fg = utils.get_color("Normal", "fg"), italic = false })
            vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = utils.color_changer.darken(utils.get_color("Normal", "bg"), 0.40) })

        end
        c.bg = utils.get_color("Normal", "bg")
        c.fg = utils.get_color("Normal", "fg")
        c.func = utils.get_color("Function", "fg")
        c.string = utils.get_color("String", "fg")
        c.operator = utils.get_color("Operator", "fg")
        c.constant = utils.get_color("Constant", "fg")
        c.warning = utils.get_color("@comment.warning", "fg")

        utils.hl_overwrite({
            SnacksImageMath = { fg = c.constant, bg = c.bg },
            SnacksPickerBorder = { fg = c.bg, bg = c.bg },
            SnacksPickerInput = { fg = c.fg, bg = c.alt },
            SnacksPickerNormal = { fg = c.fg, bg = c.alt },
            SnacksPickerMatch = { fg = c.warning, bg = "none" },
            SnacksPickerInputBorder = { fg = c.alt, bg = c.alt },
            SnacksPickerBoxBorder = { fg = c.alt, bg = c.alt },
            SnacksPickerTitle = { fg = c.bg, bg = c.operator },
            SnacksPickerBoxTitle = { fg = c.bg, bg = c.string },
            SnacksPickerListCursorLine = { fg = "none", bg = c.line },
            SnacksPickerList = { bg = c.alt, fg = c.fg },
            SnacksPickerPrompt = { fg = c.func, bg = c.alt },
            SnacksPickerPreviewTitle = { fg = c.bg, bg = c.func },
            SnacksPickerPreview = { bg = c.bg },
            SnacksPickerToggle = { bg = c.func, fg = c.bg },
            SnacksPickerDir = { fg = c.operator },
            SnacksPickerSelected = { link = "Type" },
            StatusLine = { fg = "none", bg = c.alt },
            StatusLineNC = { fg = "none", bg = c.alt },
            WinSeparator = { fg = c.fg, bg = "none" },
            Directory = { bg = "none" },
            FloatBorder = { fg = c.fg, bg = "none" },
            LineNr = { bg = "none" },
            NormalFloat = { bg = "none" },
            BlinkCmpMenu = { link = "Normal" },
            BlinkCmpSignatureHelpActiveParameter = { link = "Normal" },
            CursorLine = { bg = c.line },
            TreesitterContext = { link="Normal" },
            TreesitterContextLineNumber = { link="LineNr" },
            TreesitterContextSeparator = { link="Comment" },
        })
    end)
end

return M
