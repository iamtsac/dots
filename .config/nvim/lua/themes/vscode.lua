local M = {}

function M.setup(style, utils)
    vim.o.winborder = "rounded"
    vim.opt.background = style
    local c = require("vscode.colors").get_colors()
    require("vscode").setup({
        transparent = true, italic_comments = true, italic_inlayhints = true,
        underline_links = true, disable_nvimtree_bg = true, terminal_colors = true,
    })
    vim.cmd("colorscheme vscode")

    if style == "dark" then
        c.bg_dim = "#252525"
        c.fg = c.vscFront
        c.bg = c.vscBack
        utils.hl_overwrite({
            SnacksImageMath = { fg = c.bg, bg = c.fg },
            SnacksPickerBorder = { fg = c.bg, bg = c.bg },
            SnacksPickerInput = { fg = c.fg, bg = c.bg_dim },
            SnacksPickerNormal = { fg = c.fg, bg = c.bg_dim },
            SnacksPickerMatch = { fg = utils.get_color("@comment.warning", "fg"), bg = nil },
            SnacksPickerInputBorder = { fg = c.bg_dim, bg = c.bg_dim },
            SnacksPickerBoxBorder = { fg = c.bg_dim, bg = c.bg_dim },
            SnacksPickerTitle = { fg = c.bg, bg = c.vscLightRed },
            SnacksPickerBoxTitle = { fg = c.bg, bg = c.vscGreen },
            SnacksPickerListCursorLine = { fg = c.fg, bg = c.vscContext },
            SnacksPickerList = { bg = c.bg_dim },
            SnacksPickerPrompt = { fg = c.vscLightRed, bg = c.bg_dim },
            SnacksPickerPreviewTitle = { fg = c.bg, bg = c.vscLightRed },
            SnacksPickerPreview = { bg = c.bg },
            SnacksPickerToggle = { bg = c.vscLightRed, fg = c.bg },
            SnacksPickerDir = { fg = c.vscPink },
            SnacksPickerSelected = { link = "Type" },
            StatusLine = { fg = nil, bg = c.bg_dim },
            StatusLineNC = { fg = nil, bg = c.bg_dim },
            CursorLine = { bg = c.bg_dim },
            LineNr = { fg = vscPopupFront, bg = c.vscCursorDarkDark },
            LineNrAbove = { fg = c.vscSplitLight, bg = c.vscCursorDarkDark },
            LineNrBelow = { fg = c.vscSplitLight, bg = c.vscCursorDarkDark },
        })
        vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.fg, italic = false })
        vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#777777" })
        utils.hl_markdown_code(c.bg, c.bg_dim)
    end

    if style == "light" then
        c.bg_dim = "#f3f3f3"
        c.fg = c.vscFront
        c.bg = c.vscBack
        utils.hl_overwrite({
            SnacksImageMath = { fg = c.fg, bg = c.bg },
            SnacksPickerBorder = { fg = c.bg, bg = c.bg },
            SnacksPickerInput = { fg = c.fg, bg = c.bg_dim },
            SnacksPickerNormal = { fg = c.fg, bg = c.bg_dim },
            SnacksPickerMatch = { link = "@diff.delta" },
            SnacksPickerInputBorder = { fg = c.bg_dim, bg = c.bg_dim },
            SnacksPickerBoxBorder = { fg = c.bg_dim, bg = c.bg_dim },
            SnacksPickerTitle = { fg = c.bg, bg = c.vscDiffRedLight },
            SnacksPickerBoxTitle = { fg = c.bg, bg = c.vscDiffRedLight },
            SnacksPickerListCursorLine = { fg = c.fg, bg = c.vscDiffGreenLight },
            SnacksPickerList = { bg = c.bg_dim },
            SnacksPickerPrompt = { fg = c.vscPopupFront, bg = c.bg_dim },
            SnacksPickerPreviewTitle = { fg = c.bg, bg = c.vscDiffRedLight },
            SnacksPickerPreview = { bg = c.bg },
            SnacksPickerToggle = { bg = c.vscDiffGreenCurrent, fg = c.bg },
            SnacksPickerDir = { fg = c.vscGitSubmodule },
            SnacksPickerSelected = { link = "Number" },
            StatusLine = { fg = nil, bg = c.bg_dim },
            StatusLineNC = { fg = nil, bg = c.bg_dim },
            BlinkCmpMenu = { link = "Normal" },
            BlinkCmpMenuBorder = { link = "Normal" },
            BlinkCmpLabelDetail = { link = "Type" },
            PmenuKind = { bg = nil },
            PmenuExtra = { bg = nil },
            NormalFloat = { bg = nil },
            CursorLine = { bg = c.bg_dim },
            LineNr = { fg = c.vscCursorDark },
            RenderMarkdownH1Bg = { bg = nil },
            RenderMarkdownH2Bg = { bg = nil },
            RenderMarkdownH3Bg = { bg = nil },
            RenderMarkdownH4Bg = { bg = nil },
            RenderMarkdownH5Bg = { bg = nil },
            RenderMarkdownH6Bg = { bg = nil },
        })

        vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.fg_main, italic = false })
        vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#777777" })
    end
end

return M
