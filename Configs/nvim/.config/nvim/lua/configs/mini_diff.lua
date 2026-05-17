require("mini.diff").setup({
    -- Gutter sign configuration
    view = {
        style = "sign", -- Use the classic sign column gutter
        signs = {
            add = "+", -- Added line indicator
            change = "~", -- Modified line indicator
            delete = "-", -- Deleted line indicator
        },
    },

    mappings = {
        goto_next = "]g",
        goto_prev = "[g",
        apply = "<leader>gs", -- Stage hunk under cursor to the Git Index
        reset = "<leader>gr", -- Reset/Undo hunk under cursor back to HEAD
    },
})

local cu = require("utils.theme")
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        cu.hl_overwrite({
            MiniDiffSignAdd = { link = "GitSignsAdd" },
            MiniDiffSignChange = { link = "GitSignsChange" },
            MiniDiffSignDelete = { link = "GitSignsDelete" },
            MiniDiffOverAdd = { bg = cu.get_color("DiffAdd", "bg"), fg = "none" },
            MiniDiffOverChange = { bg = cu.get_color("DiffChange", "bg"), fg = "none" },
            MiniDiffOverDelete = { bg = cu.get_color("DiffDelete", "bg"), fg = "none" },
            MiniDiffOverChangeBuf = { bg = cu.get_color("DiffChange", "bg"), fg = "none" },
            MiniDiffOverContext = { bg = "none", fg = "none" },
            MiniDiffOverContextBuf = { bg = "none", fg = "none" },
        })
    end,
})
