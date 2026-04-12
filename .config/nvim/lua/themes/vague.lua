local M = {}

function M.setup(style, variant, utils)
    vim.o.winborder = "rounded"
    vim.opt.background = style
    c = {
        bg = "#131313",
        inactiveBg = "#1c1c24",
        fg = "#cdcdcd",
        floatBorder = "#878787",
        line = "#252530",
        comment = "#606079",
        builtin = "#b4d4cf",
        func = "#c48282",
        string = "#e8b589",
        number = "#e0a363",
        property = "#c3c3d5",
        constant = "#aeaed1",
        parameter = "#bb9dbd",
        visual = "#333738",
        error = "#d8647e",
        warning = "#f3be7c",
        hint = "#7e98e8",
        operator = "#90a0b5",
        keyword = "#6e94b2",
        type = "#9bb4bc",
        search = "#405065",
        plus = "#7fa563",
        delta = "#f3be7c",
    }

    require("vague").setup({
        transparent = false, bold = true, italic = true,
        style = {
            comments = "italic", keyword_return = "italic",
            builtin_constants = "bold", builtin_types = "bold",
        },
        colors = c,
    })

    vim.cmd("colorscheme vague")
    vim.schedule(function()
        if style == "dark" then
            c.pickerBg = utils.color_changer.lighten(c.bg, 0.03)
            utils.hl_overwrite({
                SnacksImageMath = { fg = c.bg, bg = c.fg },
                SnacksPickerBorder = { fg = c.bg, bg = c.bg },
                SnacksPickerInput = { fg = c.fg, bg = c.pickerBg },
                SnacksPickerNormal = { fg = c.fg, bg = c.pickerBg },
                SnacksPickerMatch = { fg = utils.get_color("@comment.warning", "fg"), bg = "none" },
                SnacksPickerInputBorder = { fg = c.pickerBg, bg = c.pickerBg },
                SnacksPickerBoxBorder = { fg = c.pickerBg, bg = c.pickerBg },
                SnacksPickerTitle = { fg = c.bg, bg = c.string },
                SnacksPickerBoxTitle = { fg = c.bg, bg = c.plus },
                SnacksPickerListCursorLine = { fg = "none", bg = c.line },
                SnacksPickerList = { bg = c.pickerBg },
                SnacksPickerPrompt = { fg = c.func, bg = c.pickerBg },
                SnacksPickerPreviewTitle = { fg = c.bg, bg = c.func },
                SnacksPickerPreview = { bg = c.bg },
                SnacksPickerToggle = { bg = c.func, fg = c.bg },
                SnacksPickerDir = { fg = c.parameter },
                SnacksPickerSelected = { link = "Type" },
                StatusLine = { fg = "none", bg = c.pickerBg },
                Directory = { bg = "none" },
                StatusLineNC = { fg = "none", bg = c.pickerBg },
                CursorLine = { bg = c.line },
                NormalFloat = { bg = "none" },
                LineNr = { fg = c.floatBorder, bg = "none" },
                TreesitterContext = { link="Normal" },
                TreesitterContextLineNumber = { link="LineNr" },
                TreesitterContextSeparator = { link="Comment" },
                -- RenderMarkdownCode = { bg = c.bg },
            })
            vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.fg, italic = false })
            vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = utils.color_changer.darken(c.fg, 0.5) })
        end
    end)
end

return M
