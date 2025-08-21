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

vim.g.mapleader = " "

-- Regster categories in which_key
wk.add({
    { "<leader>z", group = "Spelling", hidden = true },
    { "<leader>b", group = "Buffer" },
    { "<leader>f", group = "Files" },
    { "<leader>g", group = "Git" },
    { "<leader>h", group = "Help/Misc" },
    { "<leader>m", group = "Marks" },
    { "<leader>t", group = "Toggle" },
    { "<leader><Tab>", group = "Tabs" },
}, { prefix = "<leader>" })

-- Generic
vim.keymap.set({ "i", "n" }, "<Esc>", "<Esc>:nohls<CR>", { silent = true })

--Files specific
vim.keymap.set("n", "<leader>ff", function()
    Snacks.picker.files(snacks_opts.files_opts)
end, { desc = " Find file" })
vim.keymap.set("n", "<leader>/", function()
    Snacks.picker.grep()
end, { desc = " Grep in file" })
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
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { silent = true, desc = " Buffer Next" })
vim.keymap.set("n", "<leader>bp", function()
    Snacks.bufdelete()
end, { silent = true, desc = " Buffer Previous" })
vim.keymap.set("n", "<leader>bk", "<cmd>bd<CR>", { silent = true, desc = " Buffer Kill" })

-- Tabs
vim.keymap.set("n", "<leader><Tab><Tab>", "<cmd>tabnew<CR>", { silent = true, desc = " Tab New" })
vim.keymap.set("n", "<leader><Tab>n", "<cmd>tabnext<CR>", { silent = true, desc = " Tab Next" })
vim.keymap.set("n", "<leader><Tab>p", "<cmd>tabprevious<CR>", { silent = true, desc = " Tab Previous" })
vim.keymap.set("n", "<leader><Tab>c", "<cmd>tabclose<CR>", { silent = true, desc = " Tab Close" })

-- Help/Misc
vim.keymap.set("n", "<leader>hl", function()
    Snacks.picker.help()
end, { desc = " Help entries" })
vim.keymap.set("n", "<leader>ht", function()
    Snacks.picker.colorschemes()
end, { desc = " Change colorscheme" })
vim.keymap.set("n", "<leader>hk", function()
    Snacks.picker.keymaps()
end, { desc = " Show keybindings" })
vim.keymap.set("n", "<leader>hm", function()
    Snacks.picker.man()
end, { desc = " Show Manpages" })
vim.keymap.set("n", "<leader>hrt", "<cmd>so $HOME/.config/nvim/lua/configs/colorscheme.lua<cr>", { desc = " Reload Theme" })
vim.keymap.set("n", "<leader>hp", "<cmd>Lazy<cr>", { desc = " Plugin Manager" })
vim.keymap.set("n", "<leader>hk", function()
    Snacks.picker.keymaps()
end, { desc = " Keymaps" })
vim.keymap.set("n", "<leader>hh", function()
    Snacks.picker.highlights()
end, { desc = " Highlights" })

-- Toggle
vim.keymap.set("n", "<leader>tz", function()
    Snacks.zen()
end, { desc = " Toggle zen mode" })
vim.keymap.set("n", "<leader>tZ", function()
    Snacks.zen.zoom()
end, { desc = " Toggle zoom" })
vim.keymap.set("n", "<leader>td", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = " Toggle diagnostics" })
vim.keymap.set("n", "<leader>ta", function()
    local blink = require("blink.cmp.config")
    blink.completion.menu.auto_show = not blink.completion.menu.auto_show
end, { desc = " Toggle autocomplete" })
vim.keymap.set("n", "<leader>tw", function()
    vim.wo.wrap = not vim.wo.wrap
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
vim.keymap.set("n", "<leader>gs", function()
    Snacks.picker.git_status()
end, { desc = " Status" })
vim.keymap.set("n", "<leader>gl", function()
    Snacks.picker.git_log()
end, { desc = " Commit history" })
vim.keymap.set("n", "<leader>glf", function()
    Snacks.picker.git_log_file()
end, { desc = " File's commit history" })
vim.keymap.set("n", "<leader>gd", custom_diff, { desc = " Diff file" })
vim.keymap.set("n", "<leader>gb", function()
    Snacks.git.blame_line()
end, { desc = " Line blame" })

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
    Snacks.picker.lsp_symbols()
end, { desc = " LSP Symbols" })
vim.keymap.set("n", "<leader>lS", function()
    Snacks.picker.lsp_workspace_symbols()
end, { desc = " LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>lD", function()
    Snacks.picker.diagnostics()
end, { desc = " Diagnostics" })
vim.keymap.set("n", "<leader>ld", function()
    Snacks.picker.diagnostics_buffer()
end, { desc = " Buffer Diagnostics" })
vim.keymap.set({ "n", "x" }, "<leader>la", function()
    vim.lsp.buf.code_action()
end, { desc = " Diagnostics" })

-- later..
vim.keymap.set("n", "<leader>z=", function()
    Snacks.picker.spelling()
end, { desc = " Spell suggestions" })
