local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local previewers = require("telescope.previewers")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")

local Job = require("plenary.job")
local new_maker = function(filepath, bufnr, opts)
    filepath = vim.fn.expand(filepath)
    Job:new({
        command = "file",
        args = { "--mime-type", "-b", filepath },
        on_exit = function(j)
            local mime_type = vim.split(j:result()[1], "/")[1]
            if mime_type == "text" then
                previewers.buffer_previewer_maker(filepath, bufnr, opts)
            else
                -- maybe we want to write something to the buffer here
                vim.schedule(function()
                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
                end)
            end
        end
    }):sync()
end


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
                ["<C-Space>"] = action_layout.toggle_preview,
                ["<C-s>"] = actions.cycle_previewers_next,
                ["<C-a>"] = actions.cycle_previewers_prev,
            },
            n = {
                ["<C-Space>"] = action_layout.toggle_preview
            },
        },
        preview = {
            filesize_limit = 2, -- MB
            buffer_previewer_maker = new_maker,
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
            mappings = {
                i = {},
            },
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
            sort_mru = true,
            previewer = false,
            mappings = {
                i = {
                    ["<c-k>"] = actions.delete_buffer + actions.move_to_top
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
