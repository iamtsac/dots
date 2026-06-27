utils = require("utils.theme_utils")

local M = {}

function M.apply()
    utils.hl_overwrite({
        SnacksDashboardKey = { bg = "none" },
        SnacksDashboardDir = { bg = "none" },
        SnacksDashboardDesc = { bg = "none" },
        SnacksDashboardFile = { bg = "none" },
        SnacksDashboardIcon = { bg = "none" },
        SnacksDashboardNormal = { bg = "none" },
        SnacksDashboardSpecial = { bg = "none" },
        SnacksDashboardTitle = { bg = "none" },
        SnacksDashboardFooter = { bg = "none" },
        SnacksDashboardHeader = { bg = "none" },
        SnacksDashboardTerminal = { bg = "none" },

        MiniDiffSignAdd = { link = "GitSignsAdd" },
        MiniDiffSignChange = { link = "GitSignsChange" },
        MiniDiffSignDelete = { link = "GitSignsDelete" },
        MiniDiffOverAdd = { bg = utils.get_color("DiffAdd", "bg"), fg = "none" },
        MiniDiffOverChange = { bg = utils.get_color("DiffChange", "bg"), fg = "none" },
        MiniDiffOverDelete = { bg = utils.get_color("DiffDelete", "bg"), fg = "none" },
        MiniDiffOverChangeBuf = { bg = utils.get_color("DiffChange", "bg"), fg = "none" },
        MiniDiffOverContext = { bg = "none", fg = "none" },
        MiniDiffOverContextBuf = { bg = "none", fg = "none" },

        CodeDiffCharInsert = { undercurl = true, sp = utils.get_color("DiffAdd", "fg") },
        CodeDiffCharDelete = { undercurl = true, sp = utils.get_color("DiffDelete", "fg") },
        CodeDiffCharMove = {
            undercurl = true,
            sp = utils.get_color("CodeDiffCharMove", "fg") or utils.get_color("DiffChange", "fg"),
        },

        EndOfBuffer = { fg = utils.get_color("Normal", "bg") },
        SnacksWinBar = { bg = utils.get_color("Normal", "bg") },
    })

    bg = utils.get_color("Normal", "bg")
    fg = utils.get_color("Normal", "fg")
    if vim.o.background == "dark" then
        utils.hl_overwrite({
            StatusLine = { fg = "none", bg = utils.color_changer.lighten(bg, 0.015) },
            StatusLineNC = { fg = bg, bg = bg },
            StatusLineMain = { fg = fg, italic = false },
            StatusLineSecondary = { fg = utils.color_changer.darken(fg, 0.35) },
            SnacksTerminalBorder = { fg = utils.color_changer.darken(fg, 0.81), bg = "NONE" },
        })
    else
        utils.hl_overwrite({
            StatusLine = { fg = "none", bg = utils.color_changer.darken(bg, 0.05) },
            StatusLineNC = { fg = "none", bg = bg },
            StatusLineMain = { fg = fg, italic = false },
            StatusLineSecondary = { fg = utils.color_changer.darken(fg, 0.35) },
            SnacksTerminalBorder = { fg = utils.color_changer.lighten(fg, 0.73), bg = "NONE" },
        })
    end
end

local original_comment_hl = nil
vim.api.nvim_create_autocmd("User", {
    pattern = "CodeDiffOpen",
    callback = function()
        -- vim.g.codediff_saved_showtabline = vim.o.showtabline
        -- vim.o.showtabline = 0
        vim.t.tabname = "Diff Mode"
        original_comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
        utils.hl_overwrite({ Comment = { italic = true, fg = utils.get_color("Normal", "fg") } })
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "CodeDiffClose",
    callback = function()
        if original_comment_hl then
            vim.api.nvim_set_hl(0, "Comment", original_comment_hl)
            original_comment_hl = nil
        end
    end,
})

return M
