local wk = require("which-key")
local conform = require("conform")
local gs = require("gitsigns")
local oil = require("oil")
local snacks_opts = require("configs/snacks_configs").snacks_config()

wk.setup({
    delay = 1000,
    preset = "classic",
    win = { border = "none" },
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
    { "<leader>s", group = "Search", icon = "󰍉" }, -- Consolidated Search
    { "<leader>t", group = "Toggle", icon = "󰔡" },
    { "<leader>c", group = "Compile", icon = "󰄲" },
    { "<leader><Tab>", group = "Tabs", icon = "󰓩" },
    { "[", group = "Prev (Structural)", icon = "󰮳" },
    { "]", group = "Next (Structural)", icon = "󰮵" },
})


vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Highlight" })

vim.keymap.set({ "n", "v" }, "=", function()
    conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 })
end, { desc = "Format File" })

vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files(snacks_opts.files_opts) end, { desc = "Find File" })
vim.keymap.set("n", "<leader>fF", function() Snacks.picker.smart(snacks_opts.smart_opts) end, { desc = "Smart Find" })
vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
vim.keymap.set("n", "<leader>fe", oil_custom, { desc = "File Explorer (Oil)" })

-- Search (<leader>s)
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep (Project)" })
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.grep_buffers() end, { desc = "Grep (Open Buffers)" })
vim.keymap.set("n", "<leader>sl", function() Snacks.picker.lines() end, { desc = "Search Lines" })
vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Search Jumps" })
vim.keymap.set("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Search Undo History" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Search Word/Selection" })
vim.keymap.set({ "n", "v" }, "<leader>sz", function() Snacks.picker.spelling() end, { desc = "Spell Suggestions" })

-- =============================================================================
-- 5. Buffer & Tab Management
-- =============================================================================
vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers(snacks_opts.buffer_opts) end, { desc = "Buffer Switch" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprev<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<leader>bk", function() Snacks.bufdelete() end, { desc = "Kill Buffer" })

-- Tabs
vim.keymap.set("n", "<leader><Tab>c", "<cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><Tab>n", "<cmd>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><Tab>p", "<cmd>tabprevious<CR>", { desc = "Prev Tab" })
vim.keymap.set("n", "<leader><Tab>k", "<cmd>tabclose<CR>", { desc = "Close Tab" })

-- =============================================================================
-- 6. Toggle
-- =============================================================================
vim.keymap.set("n", "<leader>tZ", function() Snacks.zen() end, { desc = " Toggle zen mode" })
vim.keymap.set("n", "<leader>tc", "<cmd>TSContext toggle<cr>", { desc = " Toggle TS Context mode" })
vim.keymap.set("n", "<leader>tz", function() Snacks.zen.zoom() end, { desc = " Toggle zoom" })
vim.keymap.set("n", "<leader>td", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = " Toggle diagnostics" })
vim.keymap.set("n", "<C-K>", function() vim.diagnostic.open_float() end, { desc = " View current diagnostic" })
vim.keymap.set("n", "<leader>tm", "<cmd>RenderMarkdown toggle<CR>", { desc = " Toggle line wrap" })
vim.keymap.set("n", "<leader>tC", function() vim.cmd("ColorizerToggle") end, { desc = " Toggle colorizer" })


vim.keymap.set("n", "<leader>ts", function()
    local new_state = not (vim.g.snacks_scroll ~= false)
    vim.g.snacks_scroll = new_state
    local status = new_state and "Enabled" or "Disabled"
end, { desc = "Toggle Smooth Scroll (Global)" })

vim.keymap.set("n", "<leader>ta", function()
    local blink = require("blink.cmp.config")
    blink.completion.menu.auto_show = not blink.completion.menu.auto_show
end, { desc = " Toggle autocomplete" })

vim.keymap.set("n", "<leader>tw", function()
    if vim.opt.textwidth:get() == 0 then
        vim.opt_local.textwidth = 80
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        print("Wrapping Enabled")
    else
        vim.opt_local.textwidth = 0
        vim.opt_local.wrap = false
        print("Wrapping disabled")
    end
end, { desc = " Toggle line wrap" })

-- =============================================================================
-- 7. Git Integration
-- =============================================================================
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_files() end, { desc = "Git Files" })
vim.keymap.set("n", "<leader>gB", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>gS", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log_line() end, { desc = "Git Log (Line)" })
vim.keymap.set("n", "<leader>gH", function() Snacks.picker.git_log() end, { desc = "Git Log (Project)" })
vim.keymap.set("n", "<leader>gh", function() Snacks.picker.git_log_file() end, { desc = "Git Log (File)" })
vim.keymap.set("n", "<leader>gd", custom_diff, { desc = "Diff File" })
vim.keymap.set("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Git Blame" })

-- Hunk Management
vim.keymap.set({ "n", "v" }, "<leader>gs", gs.stage_hunk, { desc = "Stage Hunk" })
vim.keymap.set({ "n", "v" }, "<leader>gr", gs.reset_hunk, { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>gp", gs.preview_hunk_inline, { desc = "Preview Hunk" })
vim.keymap.set("n", "]g", gs.nav_hunk, { desc = "Next Hunk" })
vim.keymap.set("n", "[g", function() gs.nav_hunk("prev") end, { desc = "Prev Hunk" })

-- =============================================================================
-- 8. LSP (Navigation & Actions)
-- =============================================================================
vim.keymap.set("n", "<leader>ld", function() Snacks.picker.lsp_definitions() end, { desc = "Definition" })
vim.keymap.set("n", "<leader>lD", function() Snacks.picker.lsp_declarations() end, { desc = "Declaration" })
vim.keymap.set("n", "<leader>lr", function() Snacks.picker.lsp_references() end, { desc = "References" })
vim.keymap.set("n", "<leader>li", function() Snacks.picker.lsp_implementations() end, { desc = "Implementation" })
vim.keymap.set("n", "<leader>ly", function() Snacks.picker.lsp_type_definitions() end, { desc = "Type Definition" })
vim.keymap.set("n", "<leader>lci", function() Snacks.picker.lsp_incoming_calls() end, { desc = "Incoming Calls" })
vim.keymap.set("n", "<leader>lco", function() Snacks.picker.lsp_outgoing_calls() end, { desc = "Outgoing Calls" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { desc = "Rename Symbol" })

-- Diagnostics (mnemonic e/E for Error)
vim.keymap.set("n", "<leader>le", function() Snacks.picker.diagnostics() end, { desc = "Project Errors" })
vim.keymap.set("n", "<leader>lE", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Errors" })
vim.keymap.set("n", "<C-K>", vim.diagnostic.open_float, { desc = "View Diagnostic" })

-- Symbols
local sym_opts = { layout = snacks_opts.simple_layout, keep_parents = true }
vim.keymap.set("n", "<leader>ls", function() Snacks.picker.lsp_symbols(sym_opts) end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>lS", function() Snacks.picker.lsp_workspace_symbols(sym_opts) end, { desc = "LSP Workspace Symbols" })

-- =============================================================================
-- 9. Tree-sitter & Movement
-- =============================================================================
local ts_select = require("nvim-treesitter-textobjects.select")
local ts_move = require("nvim-treesitter-textobjects.move")
local ts_swap = require("nvim-treesitter-textobjects.swap")

-- Select (af, if, ac, ic)
vim.keymap.set({ "x", "o" }, "af", function() ts_select.select_textobject("@function.outer") end, { desc = "Outer Function" })
vim.keymap.set({ "x", "o" }, "if", function() ts_select.select_textobject("@function.inner") end, { desc = "Inner Function" })

-- Swap
vim.keymap.set("n", "<C-S-J>", function() ts_swap.swap_next("@parameter.inner") end, { desc = "Swap Next Param" })
vim.keymap.set("n", "<C-S-K>", function() ts_swap.swap_previous("@parameter.inner") end, { desc = "Swap Prev Param" })

-- Structural Movement
vim.keymap.set({ "n", "x", "o" }, "]f", function() ts_move.goto_next_start("@function.outer") end, { desc = "Next Function" })
vim.keymap.set({ "n", "x", "o" }, "[f", function() ts_move.goto_previous_start("@function.outer") end, { desc = "Prev Function" })
vim.keymap.set({ "n", "x", "o" }, "]]", function() ts_move.goto_next_start("@class.outer") end, { desc = "Next Class" })
vim.keymap.set({ "n", "x", "o" }, "[[", function() ts_move.goto_previous_start("@class.outer") end, { desc = "Prev Class" })
vim.keymap.set({ "n", "x", "o" }, "]c", function() ts_move.goto_next("@conditional.outer") end, { desc = "Next Conditional" })
vim.keymap.set({ "n", "x", "o" }, "[c", function() ts_move.goto_previous("@conditional.outer") end, { desc = "Prev Conditional" })

-- =============================================================================
-- 10. Help & Misc
-- =============================================================================
vim.keymap.set("n", "<leader>hk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>hr", "<cmd>source $MYVIMRC<cr>", { desc = "Reload Config" })
vim.keymap.set("n", "<leader>hp", "<cmd>Lazy<cr>", { desc = "Plugin Manager" })
vim.keymap.set("n", "<leader>co", "<cmd>OverseerToggle<CR>", { desc = "Compile/Overseer" })
vim.keymap.set("n", "<leader>hh", function() Snacks.picker.highlights() end, { desc = " Highlights" })
vim.keymap.set("n", "<leader>hl", function() Snacks.picker.help() end, { desc = " Help entries" })
vim.keymap.set("n", "<leader>ht", function() require("utils.theme_picker").theme_picker() end, { desc = " Choose optimized colorscheme" })
vim.keymap.set("n", "<leader>hT", function() Snacks.picker.colorschemes() end, { desc = " Change colorscheme" })
vim.keymap.set("n", "<leader>hm", function() Snacks.picker.man() end, { desc = " Show Manpages" })
vim.keymap.set("n", "<leader>hM", "<cmd>Mason<CR>", { desc = " Mason" })
