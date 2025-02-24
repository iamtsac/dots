local M = {}

function M.snacks_config()
    local conf = {}

    conf.picker_layout = {
        layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.4,
            border = "top",
            title = " {title} {live} {flags}",
            title_pos = "center",
            {
                win = "input",
                height = 1,
                border = "bottom",
                width = 0.,
            },
            {
                box = "horizontal",
                {
                    win = "list",
                    border = "none",
                },
                {
                    win = "preview",
                    title = "{preview}",
                    title_pos = "center",
                    width = 0.5,
                    border = "none",
                    wo = {
                        number = false,
                        signcolumn = "yes:4",
                    },
                },
            },
        },
    }

    conf.files_opts = {
        finder = "files",
        format = "file",
        cmd = "rg",
        show_empty = true,
        hidden = false,
        ignored = false,
        follow = false,
        supports_live = true,
    }

    conf.buffer_opts = {
        finder = "buffers",
        format = "buffer",
        hidden = false,
        unloaded = true,
        current = false,
        sort_lastused = true,
        win = {
            input = {
                keys = {
                    ["<c-k>"] = { "bufdelete", mode = { "n", "i" } },
                },
            },
            list = { keys = { ["dd"] = "bufdelete" } },
        },
    }

    conf.picker = {
        enabled = true,
        layout = conf.picker_layout,
        win = {
            input = {
                keys = {
                    ["<c-space>"] = { "toggle_preview", mode = { "i", "n" } },
                    ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                    ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                    ["<c-f>"] = { "list_scroll_down", mode = { "i", "n" } },
                    ["<c-b>"] = { "list_scroll_up", mode = { "i", "n" } },
                    ["<c-j>"] = { "history_forward", mode = { "i", "n" } },
                    ["<c-k>"] = { "history_back", mode = { "i", "n" } },
                },
            },
            list = {
                keys = {
                    ["<c-space>"] = "toggle_preview",
                    ["<c-u>"] = "preview_scroll_up",
                    ["<c-d>"] = "preview_scroll_down",
                    ["<c-b>"] = "list_scroll_up",
                    ["<c-f>"] = "list_scroll_down",
                },
            },
        },
    }

    conf.statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
            open = false, -- show open fold icons
            git_hl = true, -- use Git Signs hl for fold icons
        },
        git = {
            -- patterns to match Git signs
            patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
    }

    conf.indent = {
        indent = {
            priority = 200,
            enabled = true, -- enable indent guides
            char = "│",
            only_scope = true, -- only show indent guides of the scope
            only_current = true, -- only show indent guides in the current window
            hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
        },
        animate = {
            enabled = false,
            style = "out",
            easing = "linear",
            duration = {
                step = 20, -- ms per step
                total = 500, -- maximum duration
            },
        },
        scope = {
            enabled = false, -- enable highlighting the current scope
            priority = 200,
            char = "│",
            underline = false, -- underline the start of the scope
            only_current = false, -- only show scope in the current window
            hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
        },
        chunk = {
            enabled = false,
            -- only show chunk scopes in the current window
            only_current = false,
            priority = 200,
            hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
            char = {
                corner_top = "┌",
                corner_bottom = "└",
                -- corner_top = "╭",
                -- corner_bottom = "╰",
                horizontal = "─",
                vertical = "│",
                arrow = ">",
            },
        },
        -- filter for buffers to enable indent guides
        filter = function(buf)
            return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        end,
    }

    conf.zen = {
        enabled = true,
        toggles = {
            dim = false,
            git_signs = true,
        },
        show = {
            statusline = false, -- can only be shown when using the global statusline
            tabline = false,
        },
        win = {
            enter = true,
            fixbuf = false,
            minimal = false,
            width = 0.5,
            height = 0,
            backdrop = { transparent = true, blend = 0 },
            keys = { q = false },
            zindex = 40,
            wo = {
                winhighlight = "NormalFloat:Normal",
            },
            w = {
                snacks_main = true,
            },
        },
    }

    conf.dim = {
      scope = {
        min_size = 5,
        max_size = 20,
        siblings = true,
      },
      animate = {
        enabled = false,
        easing = "outQuad",
        duration = {
          step = 20, -- ms per step
          total = 300, -- maximum duration
        },
      },
      filter = function(buf)
        return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
      end
    }

    return conf
end

return M
