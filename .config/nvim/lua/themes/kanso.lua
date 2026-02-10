local M = {}

function M.setup(style, utils)
    vim.o.winborder = "rounded"
    vim.opt.background = style
    require("kanso").setup({
        bold = true, italics = false, compile = false, undercurl = true,
        commentStyle = { italic = true }, functionStyle = {}, keywordStyle = { italic = false },
        statementStyle = {}, typeStyle = {}, transparent = true, dimInactive = false,
        terminalColors = true,
        background = { dark = "zen", light = "pearl" },
    })

    local c = {
        springViolet1 = "#938AA9", springGreen = "#98BB6C", zenRed = "#E46876",
        pearlWhite1 = "#e2e1df", pearlWhite2 = "#dddddb", pearlViolet4 = "#624c83",
        pearlYellow4 = "#f9d791", gray0 = "#111111", gray2 = "#181818", gray3 = "#282828",
    }

    vim.cmd("colorscheme kanso")
    c.fg = utils.get_color("Normal", "fg")

    if style == "dark" then
        c.bg = "#000000"
        c.markdown_code = c.gray2
        utils.hl_overwrite({
            SnacksPickerBorder = { fg = c.bg, bg = c.bg },
            SnacksPickerInput = { fg = c.fg, bg = c.gray0 },
            SnacksPickerNormal = { fg = c.fg, bg = c.gray0 },
            SnacksPickerMatch = { link = "Type" },
            SnacksPickerInputBorder = { fg = c.gray0, bg = c.gray0 },
            SnacksPickerBoxBorder = { fg = c.gray0, bg = c.gray0 },
            SnacksPickerTitle = { fg = c.bg, bg = c.springGreen },
            SnacksPickerBoxTitle = { fg = c.gray0, bg = c.springGreen },
            SnacksPickerList = { bg = c.gray0 },
            SnacksPickerPrompt = { fg = c.zenRed, bg = c.gray0 },
            SnacksPickerPreviewTitle = { fg = c.bg, bg = c.zenRed },
            SnacksPickerPreview = { bg = c.bg },
            SnacksPickerToggle = { bg = c.springGreen, fg = c.bg },
            SnacksPickerDir = { fg = c.springViolet1 },
            SnacksPickerSelected = { link = "Type" },

            StatusLine = { fg = nil, bg = c.gray2 },
            CursorLine = { fg = nil, bg = c.gray0 },
            StatusLineNC = { fg = nil, bg = c.gray2 },

            Normal = { bg = nil },
            NormalFloat = { bg = nil },
            NormalNC = { bg = nil },
            SignColumn = { bg = nil },

            BlinkCmpMenu = { link = "Normal" },
            BlinkCmpScrollBarThumb = { bg = c.fg },
            BlinkCmpMenuSelection = { bg = c.gray3 },
            BlinkCmpSignatureHelpActiveParameter = { link = "Normal" },
            RenderMarkdownCode = { bg = c.bg },
        })

        vim.api.nvim_set_hl(0, "StatusLineMain", { fg = "#DDDDDD", italic = false })
        vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#888888" })

    elseif style == "light" then
        c.bg = "#EEEEEE"
        c.markdown_code = c.pearlWhite2
        utils.hl_overwrite({
            SnacksImageMath = { fg = c.fg, bg = c.bg },
            SnacksPickerBorder = { fg = c.bg, bg = c.bg },
            SnacksPickerInput = { fg = c.fg, bg = c.pearlWhite1 },
            SnacksPickerNormal = { fg = c.fg, bg = c.pearlWhite1 },
            SnacksPickerMatch = { link = "Boolean" },
            SnacksPickerInputBorder = { fg = c.pearlWhite1, bg = c.pearlWhite1 },
            SnacksPickerBoxBorder = { fg = c.pearlWhite1, bg = c.pearlWhite1 },
            SnacksPickerTitle = { fg = c.bg, bg = c.springGreen },
            SnacksPickerBoxTitle = { fg = c.gray0, bg = c.springGreen },
            SnacksPickerListCursorLine = { fg = c.gray0, bg = c.pearlYellow4 },
            SnacksPickerList = { bg = c.pearlWhite1 },
            SnacksPickerPrompt = { fg = c.zenRed, bg = c.pearlWhite1 },
            SnacksPickerPreviewTitle = { fg = c.bg, bg = c.zenRed },
            SnacksPickerPreview = { bg = c.bg },
            SnacksPickerToggle = { bg = c.springGreen, fg = c.bg },
            SnacksPickerDir = { fg = c.pearlViolet4 },
            SnacksPickerSelected = { link = "Type" },
            StatusLine = { fg = nil, bg = c.pearlWhite1 },
            StatusLineNC = { fg = nil, bg = c.pearlWhite1 },
            RenderMarkdownCode = { bg = c.bg },
        })
        vim.api.nvim_set_hl(0, "StatusLineMain", { fg = "#000000", italic = false })
        vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#777777" })
    end

    utils.hl_markdown_code(c.bg, c.markdown_code)
end

return M
