require("nvim-treesitter").setup({
    ensure_installed = {
        "cpp", "python", "lua", "typst", "regex", "markdown",
        "markdown_inline", "html", "css", "javascript", "scss",
        "svelte", "vue", "vim", "vimdoc", "query" -- Added these 4 for stability
    },
    auto_install = false,
    sync_install = true,
    ignore_install = { "tmux" },
    highlight = {
        enable = true,
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
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
    -- Textobjects configuration moved INSIDE the main setup
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
            selection_modes = {
                ["@parameter.outer"] = "v",
                ["@function.outer"] = "V",
            },
            include_surrounding_whitespace = false,
        },
        move = {
            enable = true,
            set_jumps = true,
        },
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
