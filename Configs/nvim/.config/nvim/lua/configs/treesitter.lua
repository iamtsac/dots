require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "cpp",
        "python",
        "lua",
        "typst",
        "regex",
        "markdown",
        "markdown_inline",
        "html",
        "css",
        "javascript",
        "scss",
        "svelte",
        "vue",
    },
    auto_install = false,
    sync_install = true,
    ignore_install = { "tmux" },
    highlight = {
        enable = true,
        disable = {},
        -- disable = function(lang, buf)
        --     local max_filesize = 100 * 1024 -- 100 KB
        --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --     if ok and stats and stats.size > max_filesize then
        --         return true
        --     end
        -- end,
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    },
    indent = {
        enable = true,
    },
})

require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
        selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
        },
        include_surrounding_whitespace = false,
    },
    move = {
        enable = true,
        set_jumps = true, -- Records jumps in the jumplist
    },
    select = {
        enable = true,
        lookahead = true,
    },
})

require("treesitter-context").setup({
    enable = true,
    max_lines = 2,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 2,
    trim_scope = "inner",
    mode = "cursor",
    separator = '—',
})
