local term = require("utils.term")

local M = {}

M.picker_layout = {
    layout = {
        box = "vertical",
        backdrop = false,
        row = -1,
        width = 0,
        height = 0.48,
        border = "top",
        title = " {title} {live} {flags}",
        title_pos = "left",
        {
            win = "input",
            height = 1,
            border = "bottom",
            width = 0, -- Fixed trailing dot syntax error
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

M.files_opts = {
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

M.buffer_opts = {
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

M.smart_opts = {
    multi = { "buffers", "recent", "files" },
    format = "file",
    matcher = {
        cwd_bonus = true,
        frecency = true,
        sort_empty = true,
    },
    transform = "unique_file",
}

M.picker = {
    enabled = true,
    layout = M.picker_layout,
    previewers = {
        diff = {
            style = "fancy",
            hide_sidebar = true,
        },
    },
    sources = {
        git_diff = {
            layout = { preview = true },
        },
    },
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
                ["<C-t>"] = { "<C-t>", mode = { "i" }, remap = true },
                ["<C-t>p"] = { "toggle_preview", mode = { "i", "n" } },
                ["<C-t>h"] = { "toggle_hidden", mode = { "i", "n" } },
                ["<C-t>i"] = { "toggle_ignored", mode = { "i", "n" } },
                ["<C-t>f"] = { "toggle_follow", mode = { "i", "n" } },
                ["<C-t>l"] = { "toggle_live", mode = { "i", "n" } },
                ["<C-t>r"] = { "toggle_regex", mode = { "i", "n" } },
                ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                ["<C-f>"] = { "list_scroll_down", mode = { "i", "n" } },
                ["<C-b>"] = { "list_scroll_up", mode = { "i", "n" } },
                ["<C-Return>"] = { "toggle_maximize", mode = { "i", "n" } },
                ["<C-w>w"] = { "cycle_win", mode = { "i", "n" } },
                ["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
                ["<C-Up>"] = { "history_back", mode = { "i", "n" } },
                ["<C-c>"] = { "cancel", mode = "i" },
                ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
                ["<CR>"] = { "confirm", mode = { "n", "i" } },
                ["<Esc>"] = "cancel",
                ["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
                ["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
                ["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
                ["<C-a>"] = { "select_all", mode = { "n", "i" } },
                ["<C-n>"] = { "list_down", mode = { "i", "n" } },
                ["<C-p>"] = { "list_up", mode = { "i", "n" } },
                ["<C-q>"] = { "qflist", mode = { "i", "n" } },
                ["<C-s>"] = { "edit_split", mode = { "i", "n" } },
                ["<C-v>"] = { "edit_vsplit", mode = { "i", "n" } },
                ["<C-r>#"] = { "insert_alt", mode = "i" },
                ["<C-r>%"] = { "insert_filename", mode = "i" },
                ["<C-r><c-a>"] = { "insert_cWORD", mode = "i" },
                ["<C-r><c-f>"] = { "insert_file", mode = "i" },
                ["<C-r><c-l>"] = { "insert_line", mode = "i" },
                ["<C-r><c-p>"] = { "insert_file_full", mode = "i" },
                ["<C-r><c-w>"] = { "insert_cword", mode = "i" },
                ["<C-w>H"] = "layout_left",
                ["<C-w>J"] = "layout_bottom",
                ["<C-w>K"] = "layout_top",
                ["<C-w>L"] = "layout_right",
                ["?"] = "toggle_help_input",
                ["G"] = "list_bottom",
                ["gg"] = "list_top",
                ["j"] = "list_down",
                ["k"] = "list_up",
                ["q"] = "cancel",
            },
        },
        list = {
            keys = {
                ["p"] = "toggle_preview",
                ["<C-u>"] = "preview_scroll_up",
                ["<C-d>"] = "preview_scroll_down",
                ["<C-b>"] = "list_scroll_up",
                ["<C-f>"] = "list_scroll_down",
                ["<C-Return>"] = { "toggle_maximize", mode = { "i", "n" } },
                ["<C-w>w"] = { "cycle_win", mode = { "i", "n" } },
            },
        },
    },
}

M.statuscolumn = {
    enabled = true,
    left = { "sign", "mark" },
    right = { "fold", "git" },
    folds = {
        open = true,
        git_hl = true,
    },
    git = {
        patterns = { "GitSign", "MiniDiffSign" },
    },
    refresh = 50,
}

M.indent = {
    indent = {
        priority = 200,
        enabled = false,
        char = "│",
        only_scope = false,
        only_current = false,
        hl = "SnacksIndent",
    },
    animate = {
        enabled = false,
        style = "out",
        easing = "linear",
        duration = {
            step = 20,
            total = 500,
        },
    },
    scope = {
        enabled = false,
        priority = 200,
        char = "│",
        underline = false,
        only_current = false,
        hl = "SnacksIndentScope",
    },
    chunk = {
        enabled = false,
        only_current = false,
        priority = 200,
        hl = "SnacksIndentChunk",
        char = {
            corner_top = "┌",
            corner_bottom = "└",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
        },
    },
    filter = function(buf)
        return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
    end,
}

M.zen = {
    enabled = true,
    toggles = {
        dim = false,
        git_signs = true,
    },
    show = {
        statusline = false,
        tabline = false,
    },
    win = {
        enter = true,
        fixbuf = false,
        minimal = false,
        width = 0.7,
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

M.dim = {
    scope = {
        min_size = 5,
        max_size = 20,
        siblings = true,
    },
    animate = {
        enabled = false,
        easing = "outQuad",
        duration = {
            step = 20,
            total = 300,
        },
    },
    filter = function(buf)
        return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
    end,
}

M.scroll = {
    enabled = true,
    animate = {
        duration = { step = 8, total = 200 },
        easing = "linear",
    },
}

M.image_opts = {
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
    force = false,
    doc = {
        enabled = true,
        inline = false,
        float = true,
        max_width = 30,
        max_height = 30,
        conceal = function(lang, type)
            return false
        end,
    },
    img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
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
    icons = {
        math = "󰪚 ",
        chart = "󰄧 ",
        image = " ",
    },
    convert = {
        notify = false,
        mermaid = function()
            local theme = vim.o.background == "light" and "neutral" or "dark"
            return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
        end,
        magick = {
            default = { "{src}[0]", "-scale", "1920x1080>" },
            vector = { "-density", 192, "{src}[0]" },
            math = { "-density", 192, "{src}[0]", "-trim" },
            pdf = { "-density", 192, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
        },
    },
    math = {
        enabled = true,
        typst = {
            tpl = [[
        #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
        #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
        #set text(size: 12pt, fill: rgb("${color}"))
        ${header}
        ${content}]],
        },
        latex = {
            font_size = "normalize",
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

M.image_style = {
    relative = "cursor",
    border = "none",
    focusable = false,
    backdrop = false,
    row = 0,
    col = 800,
}

M.git_diff = {
    group = false,
    finder = "git_diff",
    format = "git_status",
    preview = "diff",
    matcher = { sort_empty = true },
    sort = { fields = { "score:desc", "file", "idx" } },
    win = {
        input = {
            keys = {
                ["<Tab>"] = { "git_stage", mode = { "n", "i" } },
                ["<c-r>"] = { "git_restore", mode = { "n", "i" }, nowait = true },
            },
        },
    },
}

-- stylua: ignore start
M.terminal_keys = {
    ["<C-w>v"] = { "split_v", mode = { "n", "t" }, desc = "Split layout vertically" },
    ["<C-w>s"] = { "split_h", mode = { "n", "t" }, desc = "Split layout horizontally" },
    ["<C-w>q"] = { "kill_term", mode = { "n", "t" }, desc = "Kill terminal buffer & process" },
    ["<C-w>c"] = { "kill_term", mode = { "n", "t" }, desc = "Kill terminal buffer & process" },

    ["<C-w>h"] = { function() vim.cmd("wincmd h") end, mode = "t", expr = false, desc = "Go to left window" },
    ["<C-w>j"] = { function() vim.cmd("wincmd j") end, mode = "t", expr = false, desc = "Go to down window" },
    ["<C-w>k"] = { function() vim.cmd("wincmd k") end, mode = "t", expr = false, desc = "Go to up window" },
    ["<C-w>l"] = { function() vim.cmd("wincmd l") end, mode = "t", expr = false, desc = "Go to right window" },
    ["<C-w>="] = { "equalize_windows", mode = { "n", "t" }, desc = "Equalize windows" },

    ["<C-w>H"] = { function() vim.cmd("wincmd H") end, mode = "t", expr = false, desc = "Move window left" },
    ["<C-w>J"] = { function() vim.cmd("wincmd J") end, mode = "t", expr = false, desc = "Move window down" },
    ["<C-w>K"] = { function() vim.cmd("wincmd K") end, mode = "t", expr = false, desc = "Move window up" },
    ["<C-w>L"] = { function() vim.cmd("wincmd L") end, mode = "t", expr = false, desc = "Move window right" },

    ["<C-w>+"] = { function() vim.cmd(term.resize_step .. "wincmd +") end, mode = "t", expr = false, desc = "Increase height" },
    ["<C-w>-"] = { function() vim.cmd(term.resize_step .. "wincmd -") end, mode = "t", expr = false, desc = "Decrease height" },
    ["<C-w>>"] = { function() vim.cmd(term.resize_step .. "wincmd >") end, mode = "t", expr = false, desc = "Increase width" },
    ["<C-w><"] = { function() vim.cmd(term.resize_step .. "wincmd <") end, mode = "t", expr = false, desc = "Increase width" },
    ["<C-w>_"] = { function() vim.cmd("wincmd _") end, mode = "t", expr = false, desc = "Maximize height" },
    ["<C-w>|"] = { function() vim.cmd("wincmd |") end, mode = "t", expr = false, desc = "Maximize width" },
}
-- stylua: ignore end

for i = 1, 9 do
    M.terminal_keys["<C-w>" .. i] = {
        function(self)
            term.focus_pane(self, i)
        end,
        mode = { "n", "t" },
        desc = "Focus pane " .. i,
    }
end

M.terminal = {
    passthrough = true,
    enabled = true,
    shell = "fish",
    bo = { 
        filetype = "snacks_terminal",
    },
    win = {
        stack = true,
        backdrop = false,
        wo = {
            winbar = term.get_title("%{(b:snacks_terminal.id % 10000) / 10}", "%{b:snacks_terminal.id % 10}"),
            winhighlight = "FloatBorder:SnacksTerminalBorder,WinBar:SnacksWinBar",
        },
        actions = {
            split_v = function(self)
                local pid, ws_id = term.get_context(self)
                local new_id = term.get_next_split_id(ws_id)
                if not new_id then
                    return
                end

                require("snacks").terminal.open(nil, { -- Protected snack check
                    count = new_id,
                    cwd = vim.fn.getcwd(),
                    win = { position = "right" },
                })
                vim.schedule(function()
                    pcall(vim.cmd, "wincmd =")
                end)
            end,

            split_h = function(self)
                local pid, ws_id = term.get_context(self)
                local new_id = term.get_next_split_id(ws_id)
                if not new_id then
                    return
                end

                require("snacks").terminal.open(nil, { -- Protected snack check
                    count = new_id,
                    cwd = vim.fn.getcwd(),
                    win = { position = "bottom" },
                })
                vim.schedule(function()
                    pcall(vim.cmd, "wincmd =")
                end)
            end,

            kill_term = function(self)
                local buf = self.buf
                if buf and vim.api.nvim_buf_is_valid(buf) then
                    vim.cmd("silent! noautocmd bdelete! " .. buf)
                end
                pcall(function()
                    self:close()
                end)
                vim.schedule(function()
                    pcall(vim.cmd, "doautocmd WinEnter")
                    pcall(vim.cmd, "redrawstatus!")
                end)
            end,

            equalize_windows = function()
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                    pcall(vim.api.nvim_set_option_value, "winfixwidth", false, { win = win })
                    pcall(vim.api.nvim_set_option_value, "winfixheight", false, { win = win })
                end
                vim.cmd("wincmd =")
            end,
        },
        keys = M.terminal_keys,
    },
}

local function dashboard_sections()
    local has_art = vim.fn.executable("pokemon-colorscripts") == 1
    local sections = {}
    if has_art then
        sections = {
            {
                pane = 1,
                section = "terminal",
                cmd = "pokemon-colorscripts -r --no-title --name snorlax && exec sleep infinity",
                hl = "header",
                padding = { 3, 0 },
                indent = 8,
                height = 20,
            },
            { section = "header", pane = 2 },
            { section = "keys", pane = 2, padding = { 0, 0 }, gap = 1, indent=12 },
            { section = "startup", pane = 1, padding = { 1, 0 } },
        }
    else
        sections = {
            { section = "header" }, -- pane omitted defaults to 1
            { section = "keys", pane = 2, padding = { 0, 0 }, gap = 1, indent=12 },
            { section = "startup", padding = { 0, 0 } },
        }
    end
    return sections
end

M.dashboard = {
    width = 60,
    row = nil, -- dashboard position. nil for center
    col = nil, -- dashboard position. nil for center
    pane_gap = 4, -- empty columns between vertical panes
    autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
    -- These settings are used by some built-in sections
    preset = {
        -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
        ---@type fun(cmd:string, opts:table)|nil
        pick = nil,
        -- Used by the `keys` section to show keymaps.
        -- Set your custom keymaps here.
        -- When using a function, the `items` argument are the default keymaps.
        ---@type snacks.dashboard.Item[]
        keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            {
                icon = " ",
                key = "n",
                desc = "New File/Folder",
                action = [[:lua require("utils.file_search_utils").open_file_navigator({ cwd = vim.fn.getcwd() }) ]],
            },
            {
                icon = " ",
                key = "p",
                desc = "Project",
                action = [[:lua require("utils.file_search_utils").smart_dir_jump() ]],
            },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "G", desc = "Neogit", action = ":Neogit" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
████████╗██╗ ██████╗██╗  ██╗       ████████╗██╗ ██████╗██╗  ██╗                
╚══██╔══╝██║██╔════╝██║ ██╔╝       ╚══██╔══╝██║██╔════╝██║ ██╔╝                
   ██║   ██║██║     █████╔╝           ██║   ██║██║     █████╔╝                 
   ██║   ██║██║     ██╔═██╗           ██║   ██║██║     ██╔═██╗                 
   ██║   ██║╚██████╗██║  ██╗▄█╗       ██║   ██║╚██████╗██║  ██╗▄█╗    ██╗██╗██╗
   ╚═╝   ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝       ╚═╝   ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝    ╚═╝╚═╝╚═╝
]],
    },
    -- item field formatters
    formats = {
        icon = function(item)
            if item.file and item.icon == "file" or item.icon == "directory" then
                return Snacks.dashboard.icon(item.file, item.icon)
            end
            return { item.icon, width = 2, hl = "icon" }
        end,
        footer = { "%s", align = "center" },
        header = { "%s", align = "center" },
        file = function(item, ctx)
            local fname = vim.fn.fnamemodify(item.file, ":~")
            fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
            if #fname > ctx.width then
                local dir = vim.fn.fnamemodify(fname, ":h")
                local file = vim.fn.fnamemodify(fname, ":t")
                if dir and file then
                    file = file:sub(-(ctx.width - #dir - 2))
                    fname = dir .. "/…" .. file
                end
            end
            local dir, file = fname:match("^(.*)/(.+)$")
            return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
        end,
    },
    sections = dashboard_sections(),
}

return M
