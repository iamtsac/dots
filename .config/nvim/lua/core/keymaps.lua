local wk = require("which-key")
local conform = require("conform")
local gs = require("gitsigns")
local oil = require("oil")
local snacks_opts = require("configs/snacks_configs").snacks_config()

wk.setup({
    delay = 1000,
    preset = "classic",
    win = {
        border = "none",
    },
    show_help = false,
    show_keys = false,
})

local function cat_table(x1, x2)
    local tmp = {}
    for k, v in pairs(x1) do
        tmp[k] = v
    end
    for k, v in pairs(x2) do
        tmp[k] = v
    end
    return tmp
end

local custom_diff = function()
    if vim.wo.diff then
        local buffers = vim.api.nvim_list_bufs()
        for _, bufnr in ipairs(buffers) do
            -- Check if the buffer name starts with 'gitsigns:/'
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:match("^gitsigns:/") then
                vim.api.nvim_buf_delete(bufnr, { force = true })
            end
        end
    else
        gs.diffthis()
    end
end

local oil_custom = function()
    local buffers = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(buffers) do
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("^oil:/") then
            vim.api.nvim_buf_delete(bufnr, { force = true })
            return
        end
    end
    vim.cmd("Oil")
end

-- Regster categories in which_key
wk.add({
    { "<leader>b", group = "Buffer", icon = "󰓩" },
    { "<leader>f", group = "Files", icon = "󰈔" },
    { "<leader>g", group = "Git", icon = "󰊢" },
    { "<leader>h", group = "Help/Misc", icon = "󰋖" },
    { "<leader>l", group = "LSP", icon = "󰄲" },
    { "<leader>m", group = "Marks", icon = "󰶰" },
    { "<leader>t", group = "Toggle", icon = "󰔡" },
    { "<leader>c", group = "Compile", icon = "󰄲" },
    { "<leader><Tab>", group = "Tabs", icon = "󰓩" },
    { "<leader>tg", group = "Gitsigns", icon = "󰊢" },
    { "[", group = "Prev (Structural)", icon = "󰮳" },
    { "]", group = "Next (Structural)", icon = "󰮵" },
}, { prefix = "<leader>" })

-- Generic
vim.keymap.set({ "i", "n" }, "<Esc>", "<Esc>:nohls<CR>", { silent = true })

--Files specific
vim.keymap.set("n", "<leader>ff", function()
    Snacks.picker.files(snacks_opts.files_opts)
end, { desc = " Find file" })
vim.keymap.set("n", "<leader>fF", function()
    Snacks.picker.smart(snacks_opts.smart_opts)
end, { desc = " Find file" })
vim.keymap.set("n", "<leader>/", function()
    Snacks.picker.grep()
end, { desc = " Grep in file" })
vim.keymap.set("n", "<leader>fp", function()
    Snacks.picker.projects()
end, { desc = "Projects" })
-- vim.keymap.set("n", "<leader>fE", function() Snacks.picker.explorer(snacks_opts.explorer_opts) end, { desc = " Grep in file" })

vim.keymap.set({ "n", "v" }, "=", function()
    conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 })
end, { desc = " Format file" })

vim.keymap.set("n", "<leader>fe", function()
    oil.open()
end, { desc = " Open file explorer" })

-- Buffers
vim.keymap.set("n", "<leader>,", function()
    Snacks.picker.buffers(snacks_opts.buffer_opts)
end, { desc = " Buffer Switch" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { silent = true, desc = " Next Buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprev<CR>", { silent = true, desc = " Previous Buffer" })
vim.keymap.set("n", "<leader>bk", function()
    Snacks.bufdelete()
end, { silent = true, desc = " Buffer kill" })

-- Tabs
vim.keymap.set("n", "<leader><Tab><Tab>", "<cmd>tabnew<CR>", { silent = true, desc = " Tab New" })
vim.keymap.set("n", "<leader><Tab>n", "<cmd>tabnext<CR>", { silent = true, desc = " Tab Next" })
vim.keymap.set("n", "<leader><Tab>p", "<cmd>tabprevious<CR>", { silent = true, desc = " Tab Previous" })
vim.keymap.set("n", "<leader><Tab>c", "<cmd>tabclose<CR>", { silent = true, desc = " Tab Close" })

-- Help/Misc
vim.keymap.set("n", "<leader>hu", function()
    Snacks.picker.undo()
end, { desc = "Undo History" })
vim.keymap.set("n", "<leader>hl", function()
    Snacks.picker.help()
end, { desc = " Help entries" })
vim.keymap.set("n", "<leader>ht", function()
    -- Snacks.picker.colorschemes()
    require("utils.theme_picker").theme_picker()
end, { desc = " Choose optimized colorscheme" })
vim.keymap.set("n", "<leader>hT", function()
    Snacks.picker.colorschemes()
end, { desc = " Change colorscheme" })
vim.keymap.set("n", "<leader>hk", function()
    Snacks.picker.keymaps()
end, { desc = " Show keybindings" })
vim.keymap.set("n", "<leader>hm", function()
    Snacks.picker.man()
end, { desc = " Show Manpages" })
vim.keymap.set("n", "<leader>hr", "<cmd>so $HOME/.config/nvim/init.lua<cr>", { desc = " Reload Config" })
vim.keymap.set("n", "<leader>hp", "<cmd>Lazy<cr>", { desc = " Plugin Manager" })
vim.keymap.set("n", "<leader>hk", function()
    Snacks.picker.keymaps()
end, { desc = " Keymaps" })
vim.keymap.set("n", "<leader>hh", function()
    Snacks.picker.highlights()
end, { desc = " Highlights" })

-- Toggle
vim.keymap.set("n", "<leader>tZ", function()
    Snacks.zen()
end, { desc = " Toggle zen mode" })
vim.keymap.set("n", "<leader>tc", "<cmd>TSContext toggle<cr>", { desc = " Toggle TS Context mode" })
vim.keymap.set("n", "<leader>ts", function()
    local new_state = not (vim.g.snacks_scroll ~= false)
    vim.g.snacks_scroll = new_state
    local status = new_state and "Enabled" or "Disabled"
end, { desc = "Toggle Smooth Scroll (Global)" })
vim.keymap.set("n", "<leader>tz", function()
    Snacks.zen.zoom()
end, { desc = " Toggle zoom" })
vim.keymap.set("n", "<leader>td", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = " Toggle diagnostics" })
vim.keymap.set("n", "<C-K>", function()
    vim.diagnostic.open_float()
end, { desc = " View current diagnostic" })
vim.keymap.set("n", "<leader>ta", function()
    local blink = require("blink.cmp.config")
    blink.completion.menu.auto_show = not blink.completion.menu.auto_show
end, { desc = " Toggle autocomplete" })
vim.keymap.set("n", "<leader>tw", function()
    if vim.opt.textwidth:get() == 0 then
        vim.opt_local.textwidth = 80 -- enable auto line breaks at 80 chars
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true -- wrap at word boundaries
        print("Wrapping Enabled")
    else
        vim.opt_local.textwidth = 0 -- disable auto line breaks
        vim.opt_local.wrap = false
        print("Wrapping disabled")
    end
end, { desc = " Toggle line wrap" })
vim.keymap.set("n", "<leader>tm", "<cmd>RenderMarkdown toggle<CR>", { desc = " Toggle line wrap" })
vim.keymap.set("n", "<leader>tC", function()
    vim.cmd("ColorizerToggle")
end, { desc = " Toggle colorizer" })
-- vim.keymap.set("n", "<leader>td", function() Snacks.dim.enable(snacks_opts.dim) end, { desc = " Toggle dim" })

-- Git
vim.keymap.set("n", "<leader>gf", function()
    Snacks.picker.git_files()
end, { desc = " Find file in repo" })
vim.keymap.set("n", "<leader>gB", function()
    Snacks.picker.git_branches()
end, { desc = " Branches" })
vim.keymap.set("n", "<leader>gS", function()
    Snacks.picker.git_status()
end, { desc = " Status" })
vim.keymap.set("n", "<leader>gH", function()
    Snacks.picker.git_log()
end, { desc = " Commit history" })
vim.keymap.set("n", "<leader>gh", function()
    Snacks.picker.git_log_file()
end, { desc = " File's commit history" })
vim.keymap.set("n", "<leader>gd", custom_diff, { desc = " Diff file" })
vim.keymap.set("n", "<leader>gb", function()
    Snacks.git.blame_line()
end, { desc = " Line blame" })
vim.keymap.set("n", "<leader>gD", function()
    Snacks.picker.git_diff(snacks_opts.git_diff)
end, { desc = " Line blame" })
vim.keymap.set({ "n", "v", "x" }, "<leader>gr", function()
    if vim.fn.mode() == "n" then
        gs.reset_hunk()
    else
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end
end, { desc = " Reset hunk" })
vim.keymap.set({ "n" }, "<leader>gR", function()
    gs.reset_buffer_index()
end, { desc = " Reset buffer to current index" })
vim.keymap.set("n", "<leader>gp", function()
    gs.preview_hunk_inline()
end, { desc = " Preview Hunk Blame" })
vim.keymap.set({ "n", "v" }, "[g", function()
    gs.nav_hunk("prev")
end, { desc = " Previous Git Hunk" })
vim.keymap.set({ "n", "v" }, "]g", function()
    gs.nav_hunk("next")
end, { desc = " Next Git Hunk" })
vim.keymap.set("n", "<leader>gC", function()
    gs.show_commit()
end, { desc = " Show commit" })
vim.keymap.set({ "n", "v" }, "<leader>gs", function()
    if vim.fn.mode() == "n" then
        gs.stage_hunk({ 1, vim.api.nvim_buf_line_count(0) })
    else
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end
end, { desc = " Stage hunk" })

vim.keymap.set("n", "<leader>tgn", function()
    gs.toggle_numhl()
end, { desc = " Toggle gitsigns numhl" })
vim.keymap.set("n", "<leader>tgl", function()
    gs.toggle_linehl()
end, { desc = " Toggle gitsigns linehl" })
vim.keymap.set("n", "<leader>tgs", function()
    gs.toggle_signs()
end, { desc = " Toggle gitsigns signs" })

-- Marks
vim.keymap.set("n", "<leader>ml", function()
    Snacks.picker.marks()
end, { desc = " Mark list" })

vim.keymap.set("n", "<leader>md", function()
    local char = vim.fn.getcharstr()
    local dfunc = function(char)
        if char == string.upper(char) then
            vim.api.nvim_del_mark(char)
        else
            local bufnr = vim.api.nvim_get_current_buf()
            vim.api.nvim_buf_del_mark(bufnr, char)
        end
    end
    if not pcall(dfunc, char) then
        local bufnr = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_del_mark(bufnr, char)
    end
end, { desc = " Delete mark" })

-- LSP
vim.keymap.set("n", "gd", function()
    Snacks.picker.lsp_definitions()
end, { desc = " Goto Definition" })
vim.keymap.set("n", "gD", function()
    Snacks.picker.lsp_declarations()
end, { desc = " Goto Declaration" })
vim.keymap.set("n", "grr", function()
    Snacks.picker.lsp_references()
end, { desc = " References" })
vim.keymap.set("n", "gI", function()
    Snacks.picker.lsp_implementations()
end, { desc = " Goto Implementation" })
vim.keymap.set("n", "gy", function()
    Snacks.picker.lsp_type_definitions()
end, { desc = " Goto T[y]pe Definition" })
vim.keymap.set("n", "<leader>ls", function()
    Snacks.picker.lsp_symbols({ layout = snacks_opts.simple_layout })
end, { desc = " LSP Symbols" })
vim.keymap.set("n", "<leader>lS", function()
    Snacks.picker.lsp_workspace_symbols({ layout = snacks_opts.simple_layout })
end, { desc = " LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>lD", function()
    Snacks.picker.diagnostics({ layout = snacks_opts.simple_layout })
end, { desc = " Diagnostics" })
vim.keymap.set("n", "<leader>ld", function()
    Snacks.picker.diagnostics_buffer({ layout = snacks_opts.simple_layout })
end, { desc = " Buffer Diagnostics" })
vim.keymap.set({ "n", "x" }, "<leader>la", function()
    vim.lsp.buf.code_action()
end, { desc = " Diagnostics" })

-- Tree-sitter
vim.keymap.set({ "x", "o" }, "af", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end, { desc = "Select outer function" })

vim.keymap.set({ "x", "o" }, "if", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end, { desc = "Select inner function" })

vim.keymap.set({ "x", "o" }, "ac", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end, { desc = "Select outer class" })

vim.keymap.set({ "x", "o" }, "ic", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end, { desc = "Select inner class" })

-- Tree-sitter Textobjects: Parameter Swapping
vim.keymap.set("n", "<C-S-J>", function()
    require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
end, { desc = "Swap next parameter" })

vim.keymap.set("n", "<C-S-K>", function()
    require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
end, { desc = "Swap previous parameter" })

-- Tree-sitter Textobjects: Structural Movement
vim.keymap.set({ "n", "x", "o" }, "]f", function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end, { desc = "Next function start" })

vim.keymap.set({ "n", "x", "o" }, "]m", function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end, { desc = "Next function start" })

vim.keymap.set({ "n", "x", "o" }, "]]", function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
end, { desc = "Next class start" })

vim.keymap.set({ "n", "x", "o" }, "]o", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
end, { desc = "Next loop start" })

vim.keymap.set({ "n", "x", "o" }, "]s", function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
end, { desc = "Next local scope" })

vim.keymap.set({ "n", "x", "o" }, "]z", function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
end, { desc = "Next fold start" })

vim.keymap.set({ "n", "x", "o" }, "]M", function()
    require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
end, { desc = "Next function end" })

vim.keymap.set({ "n", "x", "o" }, "][", function()
    require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
end, { desc = "Next class end" })

-- Jump to Previous
vim.keymap.set({ "n", "x", "o" }, "[f", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end, { desc = "Previous function start" })

vim.keymap.set({ "n", "x", "o" }, "[m", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end, { desc = "Previous function start" })

vim.keymap.set({ "n", "x", "o" }, "[[", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
end, { desc = "Previous class start" })

vim.keymap.set({ "n", "x", "o" }, "[M", function()
    require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
end, { desc = "Previous function end" })

vim.keymap.set({ "n", "x", "o" }, "[]", function()
    require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
end, { desc = "Previous class end" })

-- Conditional specific jumps
vim.keymap.set({ "n", "x", "o" }, "]c", function()
    require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
end, { desc = "Next conditional" })

vim.keymap.set({ "n", "x", "o" }, "[c", function()
    require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
end, { desc = "Previous conditional" })

-- later..
vim.keymap.set({ "n", "v" }, "<leader>z", function()
    Snacks.picker.spelling()
end, { desc = " Spell suggestions" })

vim.keymap.set("n", "<leader>co", function()
    vim.cmd("OverseerToggle")
end, { desc = "Compilation Log" })
