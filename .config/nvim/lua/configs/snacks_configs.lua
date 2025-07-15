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

    conf.explorer_layout = {
        preview = "main",
        layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.4,
            border = "top",
            position = "bottom",
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
        exclude = {
            "*submodules/",
            "*build/",
        },
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
        formatters = {
            file = {
                filename_first = true,
                icon_width = 3,
                truncate = 120,
            },
        },
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
                    ["<c-Return>"] = { "toggle_maximize", mode = { "i", "n" } },
                    ["<c-w>w"] = { "cycle_win", mode = { "i", "n" } },
                },
            },
            list = {
                keys = {
                    ["<c-space>"] = "toggle_preview",
                    ["<c-u>"] = "preview_scroll_up",
                    ["<c-d>"] = "preview_scroll_down",
                    ["<c-b>"] = "list_scroll_up",
                    ["<c-f>"] = "list_scroll_down",
                    ["<c-Return>"] = { "toggle_maximize", mode = { "i", "n" } },
                    ["<c-w>w"] = { "cycle_win", mode = { "i", "n" } },
                },
            },
        },
    }

    conf.statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
            open = true, -- show open fold icons
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
            enabled = false, -- enable indent guides
            char = "│",
            only_scope = false, -- only show indent guides of the scope
            only_current = false, -- only show indent guides in the current window
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
        end,
    }

    conf.scroll = {
        enabled = false,
        animate = {
            duration = { step = 5, total = 250 },
            easing = "linear",
        },
    }

    conf.explorer_opts = {
        finder = "explorer",
        sort = { fields = { "sort" } },
        supports_live = true,
        tree = true,
        watch = true,
        diagnostics = true,
        diagnostics_open = false,
        git_status = true,
        git_status_open = false,
        git_untracked = true,
        follow_file = true,
        focus = "list",
        auto_close = false,
        jump = { close = false },
        layout = conf.explorer_layout,
        -- to show the explorer to the right, add the below to
        -- your config under `opts.picker.sources.explorer`
        -- layout = { layout = { position = "right" } },
        formatters = {
            file = { filename_only = true },
            severity = { pos = "right" },
        },
        matcher = { sort_empty = false, fuzzy = false },
        config = function(opts)
            return require("snacks.picker.source.explorer").setup(opts)
        end,
        win = {
            list = {
                keys = {
                    ["<BS>"] = "explorer_up",
                    ["-"] = "explorer_up",
                    ["l"] = "confirm",
                    ["h"] = "explorer_close", -- close directory
                    ["a"] = "explorer_add",
                    ["d"] = "explorer_del",
                    ["r"] = "explorer_rename",
                    ["c"] = "explorer_copy",
                    ["m"] = "explorer_move",
                    ["o"] = "explorer_open", -- open with system application
                    ["P"] = "toggle_preview",
                    ["y"] = { "explorer_yank", mode = { "n", "x" } },
                    ["p"] = "explorer_paste",
                    ["u"] = "explorer_update",
                    ["<c-c>"] = "tcd",
                    ["<leader>/"] = "picker_grep",
                    ["<c-t>"] = "terminal",
                    ["."] = "explorer_focus",
                    ["I"] = "toggle_ignored",
                    ["H"] = "toggle_hidden",
                    ["Z"] = "explorer_close_all",
                    ["]g"] = "explorer_git_next",
                    ["[g"] = "explorer_git_prev",
                    ["]d"] = "explorer_diagnostic_next",
                    ["[d"] = "explorer_diagnostic_prev",
                    ["]w"] = "explorer_warn_next",
                    ["[w"] = "explorer_warn_prev",
                    ["]e"] = "explorer_error_next",
                    ["[e"] = "explorer_error_prev",
                },
            },
        },
    }

    conf.image_opts = {
        formats = {
            "png",
            "jpg",
            "jpeg",
            "gif",
            "bmp",
            "webp",
            "tiff",
            "heic",
            "avif",
            "mp4",
            "mov",
            "avi",
            "mkv",
            "webm",
            "pdf",
        },
        force = false, -- try displaying the image, even if the terminal does not support it
        doc = {
            -- enable image viewer for documents
            -- a treesitter parser must be available for the enabled languages.
            enabled = true,
            -- render the image inline in the buffer
            -- if your env doesn't support unicode placeholders, this will be disabled
            -- takes precedence over `opts.float` on supported terminals
            inline = false,
            -- render the image in a floating window
            -- only used if `opts.inline` is disabled
            float = true,
            max_width = 60,
            max_height = 60,
            -- Set to `true`, to conceal the image text when rendering inline.
            -- (experimental)
            ---@param lang string tree-sitter language
            ---@param type snacks.image.Type image type
            conceal = function(lang, type)
                -- only conceal math expressions
                return false
            end,
        },
        img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
        -- window options applied to windows displaying image buffers
        -- an image buffer is a buffer with `filetype=image`
        wo = {
            wrap = false,
            number = false,
            relativenumber = false,
            cursorcolumn = false,
            signcolumn = "no",
            foldcolumn = "0",
            list = false,
            spell = false,
            statuscolumn = "",
        },
        cache = vim.fn.stdpath("cache") .. "/snacks/image",
        debug = {
            request = false,
            convert = false,
            placement = false,
        },
        env = {},
        -- icons used to show where an inline image is located that is
        -- rendered below the text.
        icons = {
            math = "󰪚 ",
            chart = "󰄧 ",
            image = " ",
        },
        ---@class snacks.image.convert.Config
        convert = {
            notify = false, -- show a notification on error
            ---@type snacks.image.args
            mermaid = function()
                local theme = vim.o.background == "light" and "neutral" or "dark"
                return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
            end,
            ---@type table<string,snacks.image.args>
            magick = {
                default = { "{src}[0]", "-scale", "1920x1080>" }, -- default for raster images
                vector = { "-density", 192, "{src}[0]" }, -- used by vector images like svg
                math = { "-density", 192, "{src}[0]", "-trim" }, -- "-alpha", "off" },
                pdf = { "-density", 192, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
            },
        },
        math = {
            enabled = true, -- enable math expression rendering
            -- in the templates below, `${header}` comes from any section in your document,
            -- between a start/end header comment. Comment syntax is language-specific.
            -- * start comment: `// snacks: header start`
            -- * end comment:   `// snacks: header end`
            typst = {
                tpl = [[
        #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
        #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
        #set text(size: 12pt, fill: rgb("${color}"))
        ${header}
        ${content}]],
            },
            latex = {
                font_size = "normalize", -- see https://www.sascha-frank.com/latex-font-size.html
                -- for latex documents, the doc packages are included automatically,
                -- but you can add more packages here. Useful for markdown documents.
                packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools", "color" },
                tpl = [[
        \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
        \usepackage{${packages}}
        \begin{document}
        ${header}
        { \${font_size} \selectfont
          \color[HTML]{${color}}
        ${content}}
        \end{document}]],
            },
        },
    }

    conf.image_style = {
        relative = "win",
        border = "none",
        focusable = false,
        backdrop = false,
        row = 0,
        col = -1,
    }

    return conf
end

return M
