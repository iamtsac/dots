local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")

require('telescope').setup{
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        theme = "ivy",
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key",
                ["<esc>"] = actions.close,
                ["<C-Space>"] = action_layout.toggle_preview
            },
            n = {
                ["<C-Space>"] = action_layout.toggle_preview
            },
        },
        preview = {
            filesize_limit = 2, -- MB
        },
    },
    pickers = {
        defaults = {
            theme= "ivy",
        },
        find_files = {
            theme = "ivy",
            hidden = true,
            no_ignore = false,
            no_ignore_parents = false,
        },
        fd = {
            theme = "ivy",
            hidden = true,
            no_ignore = false,
            no_ignore_parents = false,
        },
        git_files = {
            theme = "ivy",
            hidden = true,
            no_ignore = false,
            no_ignore_parents = false,
        },
        live_grep = {
            theme = "ivy",
        },
        buffers = {
            theme = "ivy",
            ignore_current_buffer = true,
            sort_lastused = true,
            previewer = false,
            mappings = {
                i = {
                    ["<c-c>"] = actions.delete_buffer + actions.move_to_top
                }
            }
        },
        git_commits = {
            theme = "ivy",
        },
        git_bcommits = {
            theme = "ivy",
        },
        git_status = {
            theme = "ivy",
        },
        git_branches = {
            theme = "ivy",
        },
    },
    extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
    }
}
