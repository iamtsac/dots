local wk = require("which-key")
local harpoon = require("harpoon")
local conform = require("conform")
local oil = require("oil")
local snacks_opts = require("configs/snacks_configs").snacks_config()


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
    { "<leader>t", group = "Tabs" },
}, { prefix = "<leader>" })

-- Generic
vim.keymap.set({ "i", "n" }, "<Esc>", "<Esc>:nohls<CR>", { silent = true })

--Files specific
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files(snacks_opts.files_opts) end, { desc = "Find file" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Grep in file" })

vim.keymap.set({ "n", "v" }, "=", function()
    conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 })
end, { desc = "Format file" })

vim.keymap.set("n", "<leader>fe", function() oil.open_float() end, { desc = "Open file explorer" })

-- Buffers
vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers(snacks_opts.buffer_opts) end, { desc = "Buffer Switch" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { silent = true, desc = "Buffer Next" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { silent = true, desc = "Buffer Previous" })
vim.keymap.set("n", "<leader>bk", "<cmd>bd<CR>", { silent = true, desc = "Buffer Kill" })

-- Tabs
vim.keymap.set("n", "<leader>t+", "<cmd>tabnew<CR>", { silent = true, desc = "Tab New" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", { silent = true, desc = "Tab Next" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<CR>", { silent = true, desc = "Tab Previous" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { silent = true, desc = "Tab Close" })

-- Help/Misc
vim.keymap.set("n", "<leader>hl", function() Snacks.picker.help() end, { desc = "Help entries" })
vim.keymap.set("n", "<leader>ht", function() Snacks.picker.colorschemes() end, { desc = "Change colorscheme" })
vim.keymap.set("n", "<leader>hk", function() Snacks.picker.keymaps() end, { desc = "Show keybindings" })
vim.keymap.set("n", "<leader>hm", function() Snacks.picker.man() end, { desc = "Show Manpages" })
vim.keymap.set("n", "<leader>hrr", "<cmd>so $HOME/.config/nvim/init.lua<cr>", { desc = "Reload Config" })
vim.keymap.set("n", "<leader>hp", "<cmd>Lazy<cr>", { desc = "Plugin Manager" })

-- Git
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_files() end, { desc = "Find file in repo" })
vim.keymap.set("n", "<leader>gB", function() Snacks.picker.git_branches() end, { desc = "Branches" })
vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Status" })
vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Commit history" })
vim.keymap.set("n", "<leader>glf", function() Snacks.picker.git_log_file() end, { desc = "File's commit history" })
vim.keymap.set("n", "<leader>gd", custom_diff, { desc = "Diff file" })
vim.keymap.set("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Line blame" })

-- Marks
vim.keymap.set("n", "<leader>ml", function() Snacks.picker.marks() end, { desc = "Mark list" })

-- Marks
vim.keymap.set("n", "<leader>tz", function() Snacks.zen() end, { desc = "Mark list" })

-- later..
vim.keymap.set("n", "<leader>z=", function() Snacks.picker.spelling() end, { desc = "Spell suggestions" })

-- Harpoon
vim.keymap.set("n", "<leader>ba", function()
    harpoon:list():add()
end, { desc = "Append to harpoon list" })
vim.keymap.set("n", "<leader><", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle harpoon list" })

vim.keymap.set("n", "<leader>1", function()
    harpoon:list():select(1)
end, { desc = "" })
vim.keymap.set("n", "<leader>2", function()
    harpoon:list():select(2)
end, { desc = "" })
vim.keymap.set("n", "<leader>3", function()
    harpoon:list():select(3)
end, { desc = "" })
vim.keymap.set("n", "<leader>4", function()
    harpoon:list():select(4)
end, { desc = "" })
vim.keymap.set("n", "<leader>5", function()
    harpoon:list():select(5)
end, { desc = "" })
