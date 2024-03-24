local util = require("conform.util")
local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "black" },
        -- Use a sub-list to run only the first available formatter
        cpp = { "clang_format"},
        ["_"] = { "trim_whitespace" },
    }
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

