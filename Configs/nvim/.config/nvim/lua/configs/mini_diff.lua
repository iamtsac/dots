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
