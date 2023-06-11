local wk = require("which-key")
local builtin = require('telescope.builtin')
local lspconfig = require('lspconfig')

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
wk.register({
    f = { name = "File" },
    b = { name = "Buffer" },
    g = { name = "Git" },
    h = { name = "Help/Misc" },
    m = { name = "Marks" },
},
{ prefix = "<leader>" }
)

-- Generic
vim.keymap.set({'i', 'n'}, '<Esc>', '<Esc>:nohls<CR>', { silent = true })

--Files specific
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find file" })
vim.keymap.set('n', '<leader>.', builtin.find_files, { desc = "Find file" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Grep in file" })
vim.keymap.set('n', '<leader>fb', ":Telescope file_browser<cr>", { desc = "File Browser", noremap = true })

-- File Tree
vim.keymap.set('n', '<leader>fe', "<cmd>NvimTreeFindFileToggle<cr>", { desc = "Toggle File Tree" })
vim.keymap.set('n', '<C-w>f', "<cmd>NvimTreeFocus<cr>", { desc = "Focus File Tree" })

-- Buffers
vim.keymap.set('n', '<leader>bs', builtin.buffers, { desc = "Buffer Switch" })
vim.keymap.set('n', '<leader>,', builtin.buffers, { desc = "Buffer Switch" })
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { silent = true , desc = "Buffer Next"})
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { silent = true, desc = "Buffer Previous" })
vim.keymap.set('n', '<leader>bk', '<cmd>bd<CR>', { silent = true, desc = "Buffer Kill" })

-- Buffers
vim.keymap.set('n', '<leader>t', '<cmd>tabnew<CR>', { silent = true, desc = "Tab New" })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnext<CR>', { silent = true , desc = "Tab Next"})
vim.keymap.set('n', '<leader>tp', '<cmd>tabprevious<CR>', { silent = true, desc = "Tab Previous" })
vim.keymap.set('n', '<leader>tk', '<cmd>tabclose<CR>', { silent = true, desc = "Tab Close" })

-- Help/Misc
vim.keymap.set('n', '<leader>hl', builtin.help_tags, { desc = "Help entries" })
vim.keymap.set('n', '<leader>ht', builtin.colorscheme, { desc = "Change colorscheme" })
vim.keymap.set('n', '<leader>hk', builtin.keymaps, { desc = "Show keybindings" })
vim.keymap.set('n', '<leader>hm', builtin.man_pages, { desc = "Show Manpages" })
vim.keymap.set('n', '<leader>hrr', '<cmd>so $HOME/.config/nvim/init.lua<cr>', { desc = "Reload Config" })
vim.keymap.set('n', '<leader>hp', '<cmd>Lazy<cr>', { desc = "Plugin Manager" })

-- Git
vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = "Find file in repo"})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = "Branches" })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = "Status" })
vim.keymap.set('n', '<leader>gcr', builtin.git_commits, { desc = "Commit history" })
vim.keymap.set('n', '<leader>gcb', builtin.git_bcommits, { desc = "File's commit history" })

-- Marks
vim.keymap.set('n', '<leader>ml', builtin.marks, { desc = "Mark list" })

-- later..
vim.keymap.set('n', '<leader>z=', builtin.spell_suggest, { desc = "Spell suggestions" })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = "Diagnostic floating" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = "Diagnostics" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, cat_table(opts, {desc = "Go to declaration" }))
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, cat_table(opts, {desc = "Go to definition" }))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, cat_table(opts, {desc = "Go to implementation" }))
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, cat_table(opts, {desc = "Go to help" }))
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, cat_table(opts, {desc = "Add workspace folder" }))
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, cat_table(opts, {desc = "Remove workspace folder" }))
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, cat_table(opts, {desc = "List workspace folders" }))
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, cat_table(opts, {desc = "Type definition" }))
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, cat_table(opts, {desc = "Rename symbol" }))
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, cat_table(opts, {desc = "Code action" }))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, cat_table(opts, {desc = "Go to references" }))
    vim.keymap.set('n', '=', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
