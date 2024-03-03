local actions = require "telescope.actions"

require'nvim-treesitter.configs'.setup {
    ensure_installed = {"c", "cpp", "python", "lua", "markdown"},
    auto_install = true,
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
        enable = true 
    },
    textobjects = { 
        enable = true 
    },
    indent = {
        enable = true
    },
    pickers = {
        buffers = {
            mappings = {
                i = {
                    ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
                }
            }
        }
    },
}
