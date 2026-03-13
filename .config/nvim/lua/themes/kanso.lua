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
end
return M
