local wk = require("which-key")
local conform = require("conform")
local oil = require("oil")
local snacks_opts = require("configs/snacks_configs")
local neogit = require("neogit")
local term = require("utils.term")

local function reload_config()
  for name, _ in pairs(package.loaded) do
    if name:match("^core%.") or name:match("^configs%.") or name:match("^utils%.") then
      package.loaded[name] = nil
    end
  end

  if handle and not handle:is_closing() then
    handle:stop()
  end

  dofile(vim.env.MYVIMRC)
end

vim.g.in_resize_mode = false
local function window_resize_mode()
    vim.g.in_resize_mode = true
    vim.cmd('redrawstatus')

    local function opts(desc)
        return { buffer = true, noremap = true, silent = true, desc = desc }
    end

    -- Map the resizing keys
    vim.keymap.set('n', '<', '<C-w><', opts("Resize Left"))
    vim.keymap.set('n', '>', '<C-w>>', opts("Resize Right"))
    vim.keymap.set('n', '+', '<C-w>+', opts("Resize Down"))
    vim.keymap.set('n', '-', '<C-w>-', opts("Resize Up"))
    vim.keymap.set('n', '_', '<C-w>_', opts("Maximize Vertically"))
    vim.keymap.set('n', '|', '<C-w>|', opts("Maximize Horizontally"))
    vim.keymap.set('n', '=', '<C-w>=', opts("Equalize"))

    local function exit_mode()
        vim.keymap.del('n', '<', { buffer = true })
        vim.keymap.del('n', '>', { buffer = true })
        vim.keymap.del('n', '+', { buffer = true })
        vim.keymap.del('n', '-', { buffer = true })
        vim.keymap.del('n', '_', { buffer = true })
        vim.keymap.del('n', '=', { buffer = true })
        vim.keymap.del('n', '<Esc>', { buffer = true })
        vim.keymap.del('n', '<leader>tr', { buffer = true })

        vim.g.in_resize_mode = false
        vim.cmd('redrawstatus')
    end

    vim.keymap.set('n', '<Esc>', exit_mode, opts("Exit Resize Mode"))
    vim.keymap.set('n', '<leader>tr', exit_mode, opts("Exit Resize Mode"))
end

wk.setup({
    delay = 1000,
    preset = "classic",
    win = { border = "none" },
    show_help = false,
    show_keys = false,
})

-- Regster categories in which_key
wk.add({
    { "<leader>b", group = "Buffer", icon = "󰓩" },
    { "<leader>f", group = "Files", icon = "󰈔" },
    { "<leader>g", group = "Git", icon = "󰊢" },
    { "<leader>h", group = "Help/Misc", icon = "󰋖" },
    { "<leader>l", group = "LSP", icon = "󰄲" },
    { "<leader>m", group = "Marks", icon = "󰶰" },
    { "<leader>M", group = "Markdown View", icon = "" },
    { "<leader>s", group = "Search", icon = "󰍉" }, -- Consolidated Search
    { "<leader>t", group = "Toggle", icon = "󰔡" },
    { "<leader>c", group = "Compile", icon = "󰄲" },
    { "<leader><Tab>", group = "Tabs", icon = "󰓩" },
    { "[", group = "Prev (Structural)", icon = "󰮳" },
    { "]", group = "Next (Structural)", icon = "󰮵" },
})


vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Highlight" })
-- =============================================================================
-- 1. Files
-- =============================================================================
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files(snacks_opts.files_opts) end, { desc = "Find File" })
vim.keymap.set("n", "<leader>fF", function() Snacks.picker.smart(snacks_opts.smart_opts) end, { desc = "Smart Find" })
vim.keymap.set("n", "<leader>fP", function() Snacks.picker.projects() end, { desc = "Projects" })
vim.keymap.set("n", "<leader>fe", function() vim.cmd("Oil") end, { desc = "File Explorer (Oil)" })
vim.keymap.set("n", "<leader>fp", require("utils.file_search_utils").smart_dir_jump, { desc = "Smart Project Jump" })
vim.keymap.set("n", "<leader>fd", function()
  require("utils.file_search_utils").open_folder_picker({ cwd = vim.fn.getcwd() })
end, { desc = "Fuzzy Folders" })
vim.keymap.set("n", "<leader>fn", function()
  require("utils.file_search_utils").open_file_navigator({ cwd = vim.fn.getcwd() })
end, { desc = "Go-to/Create file" })
vim.keymap.set("n", "<leader>fD", function()
  require("utils.file_search_utils").open_folder_picker({ cwd = "~" })
end, { desc = "Fuzzy Folders (~)" })

-- =============================================================================
-- 2. Search
-- =============================================================================
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep (Project)" })
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.grep_buffers() end, { desc = "Grep (Open Buffers)" })
vim.keymap.set("n", "<leader>sl", function() Snacks.picker.lines() end, { desc = "Search Lines" })
vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Search Jumps" })
vim.keymap.set("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Search Undo History" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Search Word/Selection" })
vim.keymap.set({ "n", "v" }, "<leader>sz", function() Snacks.picker.spelling() end, { desc = "Spell Suggestions" })

-- =============================================================================
-- 3. Buffer & Tab Management
-- =============================================================================
vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers(snacks_opts.buffer_opts) end, { desc = "Buffer Switch" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprev<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<leader>bx", function() Snacks.bufdelete() end, { desc = "Kill Buffer" })

-- Tabs
vim.keymap.set("n", "<leader><Tab>c", function()
    vim.cmd("tabnew")
    vim.cmd("tcd ~")
    vim.t.tabname = "Untitled"
    vim.cmd("redrawtabline") 
    _G.FloatingTabs.redraw()
    Snacks.dashboard()
end, { desc = "New Tab" })
vim.keymap.set("n", "<leader><Tab>n", "<cmd>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><Tab>p", "<cmd>tabprevious<CR>", { desc = "Prev Tab" })
vim.keymap.set("n", "<leader><Tab>x", require("utils.tab_utils").safe_tab_close, { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>s",  require("utils.tab_utils").tab_picker, { desc = "Search Tabs" })
vim.keymap.set("n", "<leader><Tab>r", function()
  local name = vim.fn.input("Tab name: ")
  if name and name ~= "" then
    vim.t.tabname = name
    vim.cmd("redrawtabline") 
    _G.FloatingTabs.redraw()
  else
    vim.t.tabname = nil
    vim.cmd("redrawtabline")
    _G.FloatingTabs.redraw()
  end
end, { desc = "Set Custom Tab Name" })

for i = 1, 9 do
  vim.keymap.set("n", "<leader><Tab>" .. i, i .. "gt", { desc = "which_key_ignore" })
end

vim.keymap.set("n", "<leader><Tab>P", function()
    vim.cmd("-tabmove")
    _G.FloatingTabs.redraw()
end, { desc = "Move tab left" })
vim.keymap.set("n", "<leader><Tab>N", function()
    vim.cmd([[ +tabmove ]])
    _G.FloatingTabs.redraw()
end, { desc = "Move tab right" })
vim.keymap.set("n", "<leader><Tab>$", function()
    vim.cmd([[ $tabmove ]])
    _G.FloatingTabs.redraw()
end, { desc = "Move tab at the end" })
vim.keymap.set("n", "<leader><Tab>0", function()
    vim.cmd([[ 0tabmove ]])
    _G.FloatingTabs.redraw()
end, { desc = "Move tab at the start" })


-- =============================================================================
-- 4. Toggle
-- =============================================================================
vim.keymap.set("n", "<leader>tZ", function() Snacks.zen() end, { desc = " Toggle zen mode" })
vim.keymap.set("n", "<leader>tc", "<cmd>TSContext toggle<cr>", { desc = " Toggle TS Context mode" })
vim.keymap.set("n", "<leader>tz", function() Snacks.zen.zoom() end, { desc = " Toggle zoom" })
vim.keymap.set("n", "<leader>td", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = " Toggle diagnostics" })
vim.keymap.set("n", "<C-K>", function() vim.diagnostic.open_float() end, { desc = " View current diagnostic" })
vim.keymap.set("n", "<leader>tm", "<cmd>RenderMarkdown toggle<CR>", { desc = " Toggle line wrap" })
vim.keymap.set("n", "<leader>tC", function() vim.cmd("ColorizerToggle") end, { desc = " Toggle colorizer" })
vim.keymap.set('n', '<leader>tr', window_resize_mode, { desc = "Enter Window Resize Mode" })
vim.keymap.set('n', '<leader>th', function() 
    vim.o.cursorline = not vim.o.cursorline
    -- vim.o.cursorcolumn = not vim.o.cursorcolumn
    if vim.o.background == "light" then
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#fcf151" })
        vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#fcf151" })
    elseif vim.o.background == "dark" then
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#003554" })
        vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#003554" })
    end
end, { desc = "Toggle hightlighting" })


vim.keymap.set("n", "<leader>tS", function()
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
-- 5. Git Integration
-- =============================================================================
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_files() end, { desc = "Git Files" })
vim.keymap.set("n", "<leader>gB", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>gS", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log_line() end, { desc = "Git Log (Line)" })
vim.keymap.set("n", "<leader>gH", function() Snacks.picker.git_log() end, { desc = "Git Log (Project)" })
vim.keymap.set("n", "<leader>gh", function() Snacks.picker.git_log_file() end, { desc = "Git Log (File)" })
vim.keymap.set("n", "<leader>gg", function() neogit.open() end, { desc = "Neogit" })
--
vim.keymap.set("n", "<leader>gdd", "<cmd>CodeDiff<cr>", { desc = "Git Diff View (CodeDiff)" })
vim.keymap.set("n", "<leader>gdf", "<cmd>CodeDiff file HEAD<cr>", { desc = "Git Diff View (Current File)" })
vim.keymap.set("n", "<leader>gdc", ":CodeDiff ", { desc = "Git Diff View Command" })
vim.keymap.set("n", "<leader>gdh", "<cmd>CodeDiff history<cr>", { desc = "Git Diff History" })

vim.keymap.set("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Git Blame" })

-- Hunk Management
vim.keymap.set("v", "<leader>gs", function() require("mini.diff").operator("apply") end, { desc = "Stage selected lines" })
vim.keymap.set("v", "<leader>gr", function() require("mini.diff").operator("reset") end, { desc = "Reset selected lines" })
vim.keymap.set("n", "<leader>gp", function() require("mini.diff").toggle_overlay(0) end, { desc = "Preview Hunk (Toggle Overlay)" })
vim.keymap.set("n", "<leader>gR", function()
    local view = vim.fn.winsaveview()
    require("mini.diff").operator("reset")
    vim.cmd("normal! ggg@G")
    vim.fn.winrestview(view)
end, { desc = "Reset Buffer (All Hunks)" })

-- =============================================================================
-- 6. LSP (Navigation & Actions)
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
vim.keymap.set("n", "<leader>lR", function() 
    vim.defer_fn(function()
        vim.cmd("lsp restart") 
        vim.notify("LSP environment refreshed and restarted", vim.log.levels.INFO)
    end, 100)
end, { desc = "Restart LSP" })

-- Formating
vim.keymap.set({ "n", "v" }, "=", function()
    conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 })
end, { desc = "Format File" })


-- Diagnostics (mnemonic e/E for Error)
vim.keymap.set("n", "<leader>le", function() Snacks.picker.diagnostics() end, { desc = "Project Errors" })
vim.keymap.set("n", "<leader>lE", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Errors" })
vim.keymap.set("n", "<C-K>", vim.diagnostic.open_float, { desc = "View Diagnostic" })

-- Symbols
local sym_opts = {
    keep_parents = true,
    filter = {
        default = {
            "File",
            "Module",
            "Namespace",
            "Package",
            "Class",
            "Method",
            "Property",
            "Field",
            "Constructor",
            "Enum",
            "Interface",
            "Function",
            "Variable",
            "Constant",
            "String",
            "Number",
            "Boolean",
            "Array",
            "Object",
            "Key",
            "Null",
            "EnumMember",
            "Struct",
            "Event",
            "Operator",
            "TypeParameter",
        },
    },
}
vim.keymap.set("n", "<leader>ls", function() Snacks.picker.lsp_symbols(sym_opts) end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>lS", function() Snacks.picker.lsp_workspace_symbols(sym_opts) end, { desc = "LSP Workspace Symbols" })

-- =============================================================================
-- 7. Tree-sitter & Movement
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
vim.keymap.set({ "n", "x", "o" }, "]f", function() ts_move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next Function" })
vim.keymap.set({ "n", "x", "o" }, "[f", function() ts_move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev Function" })
vim.keymap.set({ "n", "x", "o" }, "]]", function() ts_move.goto_next_start("@class.outer") end, { desc = "Next Class" })
vim.keymap.set({ "n", "x", "o" }, "[[", function() ts_move.goto_previous_start("@class.outer") end, { desc = "Prev Class" })
vim.keymap.set({ "n", "x", "o" }, "]c", function() ts_move.goto_next("@conditional.outer") end, { desc = "Next Conditional" })
vim.keymap.set({ "n", "x", "o" }, "[c", function() ts_move.goto_previous("@conditional.outer") end, { desc = "Prev Conditional" })

-- =============================================================================
-- 8. Help & Misc
-- =============================================================================
vim.keymap.set("n", "<leader>hk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>hr", reload_config, { desc = "Reload Config" })
vim.keymap.set("n", "<leader>hp", "<cmd>Lazy<cr>", { desc = "Plugin Manager" })
vim.keymap.set("n", "<leader>co", "<cmd>OverseerToggle<CR>", { desc = "Compile/Overseer" })
vim.keymap.set("n", "<leader>hh", function() Snacks.picker.highlights() end, { desc = " Highlights" })
vim.keymap.set("n", "<leader>hl", function() Snacks.picker.help() end, { desc = " Help entries" })
vim.keymap.set("n", "<leader>ht", function() require("utils.theme_picker").theme_picker() end, { desc = " Choose optimized colorscheme" })
vim.keymap.set("n", "<leader>hT", function() Snacks.picker.colorschemes() end, { desc = " Change colorscheme" })
vim.keymap.set("n", "<leader>hm", function() Snacks.picker.man() end, { desc = " Show Manpages" })
vim.keymap.set("n", "<leader>hM", "<cmd>Mason<CR>", { desc = " Mason" })

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

-- =============================================================================
-- 9. Terminal
-- =============================================================================
vim.keymap.set("t", "<C-[><C-[>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
vim.keymap.set("t", "<C-[>", "<Esc>", { desc = "Terminal normal mode" })

vim.keymap.set("n", "<leader>ts", function()
    local ws_id = term.update_and_get_workspace()
    term.toggle_workspace_group({ ws_id = ws_id, default_style = "terminal", default_position = "bottom", height = 0.4 })
end, { desc = "Toggle Layout Workspace (Bottom)" })

vim.keymap.set("n", "<leader>tv", function()
    local ws_id = term.update_and_get_workspace()
    term.toggle_workspace_group({ ws_id = ws_id, default_style = "terminal", default_position = "right", width = 0.4 })
end, { desc = "Toggle Layout Workspace (Right)" })

local function handle_main_toggle()
    local ws_id = term.update_and_get_workspace()
    term.toggle_workspace_group({
        ws_id = ws_id,
        default_style = "float",
        default_position = "float",
        height = 0.98,
        width = 0.98,
    })
end

vim.keymap.set({ "n", "t" }, "<C-/>", handle_main_toggle, { desc = "Toggle Active Terminal Workspace" })
vim.keymap.set({ "n", "t" }, "<C-S-/>", function()
    term.toggle_last_focused_global()
end, { desc = "Toggle Global Last Used Terminal" })
vim.keymap.set("n", "<leader>tl", term.terminal_picker, { desc = "Pick Terminal Workspace" })

-- =============================================================================
-- 10. Rendering
-- =============================================================================
vim.api.nvim_set_keymap("n", "<leader>tm", "<CMD>Markview<CR>", { desc = "Toggles `markview` previews globally." });
vim.api.nvim_set_keymap("n", "<leader>Ms", "<CMD>Markview splitToggle<CR>", { desc = "Toggles `splitview` for current buffer." });
vim.api.nvim_set_keymap("n", "<leader>Mt", "<CMD>Checkbox toggle<CR>", { desc = "(.md) Toggle Checkbox" });
vim.api.nvim_set_keymap("n", "<leader>MH", "<CMD>Heading increase<CR>", { desc = "(.md) Increase Heading" });
vim.api.nvim_set_keymap("n", "<leader>Mh", "<CMD>Heading decrease<CR>", { desc = "(.md) Decrease Heading" });
vim.api.nvim_set_keymap("n", "<leader>Mc", "<CMD>Editor edit<CR>", { desc = "(.md) Open Code Editor" });
