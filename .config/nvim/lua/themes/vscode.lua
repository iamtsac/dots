local M = {}

function M.setup(style, variant, utils)
    vim.o.winborder = "rounded"
    vim.opt.background = style
    local c = require("vscode.colors").get_colors()
    require("vscode").setup({
        transparent = false, italic_comments = true, italic_inlayhints = true,
        underline_links = true, disable_nvimtree_bg = true, terminal_colors = true,
    })
    vim.cmd("colorscheme vscode")

    vim.schedule(function()
        if style == "dark" then
            c.bg_dim = utils.color_changer.lighten(utils.get_color("Normal", "bg"), 0.03)
            c.fg = c.vscFront
            c.bg = c.vscBack
            utils.hl_overwrite({
                SnacksImageMath = { fg = c.bg, bg = c.fg },
                SnacksPickerBorder = { fg = c.bg, bg = c.bg },
                SnacksPickerInput = { fg = c.fg, bg = c.bg_dim },
                SnacksPickerNormal = { fg = c.fg, bg = c.bg_dim },
                SnacksPickerMatch = { fg = utils.get_color("@comment.warning", "fg"), bg = "none" },
                SnacksPickerInputBorder = { fg = c.bg_dim, bg = c.bg_dim },
                SnacksPickerBoxBorder = { fg = c.bg_dim, bg = c.bg_dim },
                SnacksPickerTitle = { fg = c.bg, bg = c.vscLightRed },
                SnacksPickerBoxTitle = { fg = c.bg, bg = c.vscGreen },
                SnacksPickerListCursorLine = { fg = "none", bg = c.vscContext },
                SnacksPickerList = { bg = c.bg_dim },
                SnacksPickerPrompt = { fg = c.vscLightRed, bg = c.bg_dim },
                SnacksPickerPreviewTitle = { fg = c.bg, bg = c.vscLightRed },
                SnacksPickerPreview = { bg = c.bg },
                Directory = { bg = "none" },
                SnacksPickerTree = { bg = "none" },
                WhichKeyIcon = { link = "WhichKeyValue" },
                SnacksPickerToggle = { bg = c.vscLightRed, fg = c.bg },
                SnacksPickerDir = { fg = c.vscPink },
                SnacksPickerSelected = { link = "Type" },
                StatusLine = { fg = "none", bg = c.bg_dim },
                StatusLineNC = { fg = "none", bg = c.bg_dim },
                CursorLine = { bg = c.bg_dim },
                -- LineNr = { fg = vscPopupFront, bg = c.vscCursorDarkDark },
                -- LineNrAbove = { fg = c.vscSplitLight, bg = c.vscCursorDarkDark },
                -- LineNrBelow = { fg = c.vscSplitLight, bg = c.vscCursorDarkDark },
            })
            vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.fg, italic = false })
            vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#777777" })
            -- utils.hl_markdown_code(c.bg, c.bg_dim)
        end

        if style == "light" then
            c.bg_dim = utils.color_changer.darken(utils.get_color("Normal", "bg"), 0.03)
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
                SnacksPickerListCursorLine = { fg = "none", bg = c.vscDiffGreenLight },
                SnacksPickerList = { bg = c.bg_dim },
                SnacksPickerPrompt = { fg = c.vscPopupFront, bg = c.bg_dim },
                SnacksPickerPreviewTitle = { fg = c.bg, bg = c.vscDiffRedLight },
                SnacksPickerPreview = { bg = c.bg },
                SnacksPickerToggle = { bg = c.vscDiffGreenCurrent, fg = c.bg },
                SnacksPickerDir = { fg = c.vscGitSubmodule },
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
                NormalFloat = { bg = "none" },
                CursorLine = { bg = c.bg_dim },
                LineNr = { fg = c.vscCursorDark },
                WhichKeyIcon = { link = "WhichKeyValue" },
                -- RenderMarkdownH1Bg = { bg = "none" },
                -- RenderMarkdownH2Bg = { bg = "none" },
                -- RenderMarkdownH3Bg = { bg = "none" },
                -- RenderMarkdownH4Bg = { bg = "none" },
                -- RenderMarkdownH5Bg = { bg = "none" },
                -- RenderMarkdownH6Bg = { bg = "none" },
            })

            vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.fg_main, italic = false })
            vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#777777" })
        end
    end)
end

return M
