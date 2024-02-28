local wk = require("which-key")
local ts_builtin = require('telescope.builtin')

local function cat_table(x1, x2)
    local tmp = {}
    for k,v in pairs(x1) do
	tmp[k] = v
    end
    for k,v in pairs(x2) do
	tmp[k] = v
    end
    return tmp
end

vim.g.mapleader = " "

-- Regster categories in which_key
-- wk.register({
--     f = { name = "File" },
--     b = { name = "Buffer" },
--     g = { name = "Git" },
--     h = { name = "Help/Misc" },
--     m = { name = "Marks" },
--     TAB = { name = "Tabs" },
-- },
--     { prefix = "<leader>" }
-- )

-- Generic
vim.keymap.set({'i', 'n'}, '<Esc>', '<Esc>:nohls<CR>', { silent = true })

--Files specific
vim.keymap.set('n', '<leader>.', ts_builtin.fd, { desc = "Find file" })
vim.keymap.set('n', '<leader>fg', ts_builtin.live_grep, { desc = "Grep in file" })
-- vim.keymap.set('n', '<leader>fb', ":Telescope file_browser<cr>", { desc = "File Browser", noremap = true })

-- Buffers
vim.keymap.set('n', '<leader>\\', ts_builtin.buffers, { desc = "Buffer Switch" })
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { silent = true , desc = "Buffer Next"})
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { silent = true, desc = "Buffer Previous" })
vim.keymap.set('n', '<leader>bk', '<cmd>bd<CR>', { silent = true, desc = "Buffer Kill" })

-- Buffers
vim.keymap.set('n', '<leader><TAB>c', '<cmd>tabnew<CR>', { silent = true, desc = "Tab New" })
vim.keymap.set('n', '<leader><TAB>n', '<cmd>tabnext<CR>', { silent = true , desc = "Tab Next"})
vim.keymap.set('n', '<leader><TAB>p', '<cmd>tabprevious<CR>', { silent = true, desc = "Tab Previous" })
vim.keymap.set('n', '<leader><TAB>k', '<cmd>tabclose<CR>', { silent = true, desc = "Tab Close" })

-- Help/Misc
vim.keymap.set('n', '<leader>hl', ts_builtin.help_tags, { desc = "Help entries" })
vim.keymap.set('n', '<leader>ht', ts_builtin.colorscheme, { desc = "Change colorscheme" })
vim.keymap.set('n', '<leader>hk', ts_builtin.keymaps, { desc = "Show keybindings" })
vim.keymap.set('n', '<leader>hm', ts_builtin.man_pages, { desc = "Show Manpages" })
vim.keymap.set('n', '<leader>hrr', '<cmd>so $HOME/.config/nvim/init.lua<cr>', { desc = "Reload Config" })
vim.keymap.set('n', '<leader>hp', '<cmd>Lazy<cr>', { desc = "Plugin Manager" })

-- Git
vim.keymap.set('n', '<leader>gf', ts_builtin.git_files, { desc = "Find file in repo"})
vim.keymap.set('n', '<leader>gb', ts_builtin.git_branches, { desc = "Branches" })
vim.keymap.set('n', '<leader>gs', ts_builtin.git_status, { desc = "Status" })
vim.keymap.set('n', '<leader>gcr', ts_builtin.git_commits, { desc = "Commit history" })
vim.keymap.set('n', '<leader>gcb', ts_builtin.git_bcommits, { desc = "File's commit history" })

-- Marks
vim.keymap.set('n', '<leader>ml', ts_builtin.marks, { desc = "Mark list" })

-- later..
vim.keymap.set('n', '<leader>z=', ts_builtin.spell_suggest, { desc = "Spell suggestions" })
