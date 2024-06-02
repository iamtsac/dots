local wk = require("which-key")
local ts_builtin = require("telescope.builtin")
local gs = require("gitsigns")
local harpoon = require("harpoon")
local conform = require("conform")

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
wk.register({
        f = { name = "File" },
        b = { name = "Buffer" },
        g = { name = "Git" },
        h = { name = "Help/Misc" },
        m = { name = "Marks" },
        TAB = { name = "Tabs" },
}, { prefix = "<leader>" })

-- Generic
vim.keymap.set({ "i", "n" }, "<Esc>", "<Esc>:nohls<CR>", { silent = true })

--Files specific
vim.keymap.set("n", "<leader>ff", ts_builtin.fd, { desc = "Find file" })
vim.keymap.set("n", "<leader>fg", ts_builtin.live_grep, { desc = "Grep in file" })
vim.keymap.set({ "n", "v" }, "=", function()
        conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 })
end, { desc = "Format file" })
vim.keymap.set("n", "<leader>fe", oil_custom, { desc = "Open file explorer" })

-- Buffers
vim.keymap.set("n", "<leader>,", ts_builtin.buffers, { desc = "Buffer Switch" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { silent = true, desc = "Buffer Next" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { silent = true, desc = "Buffer Previous" })
vim.keymap.set("n", "<leader>bk", "<cmd>bd<CR>", { silent = true, desc = "Buffer Kill" })

-- Tabs
vim.keymap.set("n", "<leader><TAB>+", "<cmd>tabnew<CR>", { silent = true, desc = "Tab New" })
vim.keymap.set("n", "<leader><TAB>n", "<cmd>tabnext<CR>", { silent = true, desc = "Tab Next" })
vim.keymap.set("n", "<leader><TAB>p", "<cmd>tabprevious<CR>", { silent = true, desc = "Tab Previous" })
vim.keymap.set("n", "<leader><TAB>c", "<cmd>tabclose<CR>", { silent = true, desc = "Tab Close" })

-- Help/Misc
vim.keymap.set("n", "<leader>hl", ts_builtin.help_tags, { desc = "Help entries" })
vim.keymap.set("n", "<leader>ht", ts_builtin.colorscheme, { desc = "Change colorscheme" })
vim.keymap.set("n", "<leader>hk", ts_builtin.keymaps, { desc = "Show keybindings" })
vim.keymap.set("n", "<leader>hm", ts_builtin.man_pages, { desc = "Show Manpages" })
vim.keymap.set("n", "<leader>hrr", "<cmd>so $HOME/.config/nvim/init.lua<cr>", { desc = "Reload Config" })
vim.keymap.set("n", "<leader>hp", "<cmd>Lazy<cr>", { desc = "Plugin Manager" })

-- Git
vim.keymap.set("n", "<leader>gf", ts_builtin.git_files, { desc = "Find file in repo" })
vim.keymap.set("n", "<leader>gB", ts_builtin.git_branches, { desc = "Branches" })
vim.keymap.set("n", "<leader>gs", ts_builtin.git_status, { desc = "Status" })
vim.keymap.set("n", "<leader>gcr", ts_builtin.git_commits, { desc = "Commit history" })
vim.keymap.set("n", "<leader>gcb", ts_builtin.git_bcommits, { desc = "File's commit history" })
vim.keymap.set("n", "<leader>gd", custom_diff, { desc = "Diff file" })
vim.keymap.set("n", "<leader>gb", function()
        gs.blame_line({ full = true })
end, { desc = "Line blame" })

-- Marks
vim.keymap.set("n", "<leader>ml", ts_builtin.marks, { desc = "Mark list" })

-- later..
vim.keymap.set("n", "<leader>z=", ts_builtin.spell_suggest, { desc = "Spell suggestions" })

-- Harpoon
vim.keymap.set("n", "<leader>ba", function()
        harpoon:list():add()
end, { desc = "Append to harpoon list" })
vim.keymap.set("n", "<leader><", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle harpoon list" })

vim.keymap.set("n", "<leader>1", function()
        harpoon:list():select(1)
end, { desc = "Go to harpoon buffer 1" })
vim.keymap.set("n", "<leader>2", function()
        harpoon:list():select(2)
end, { desc = "Go to harpoon buffer 2" })
vim.keymap.set("n", "<leader>3", function()
        harpoon:list():select(3)
end, { desc = "Go to harpoon buffer 3" })
vim.keymap.set("n", "<leader>4", function()
        harpoon:list():select(4)
end, { desc = "Go to harpoon buffer 4" })
vim.keymap.set("n", "<leader>5", function()
        harpoon:list():select(5)
end, { desc = "Go to harpoon buffer 5" })

-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

--[[ vim.api.nvim_create_autocmd('FileType', {
    pattern = {'cpp', 'h', 'hpp', 'cc', 'c'},
    callback = function()
        vim.keymap.set("n", "=", ":w<CR>:silent !clang-format -i --style=file %<CR>", { silent = true, desc = "Format file" , buffer = true})
    end
}) ]]

-- Netwr
vim.api.nvim_create_autocmd("FileType", {
        pattern = "netrw",
        callback = function()
                local netrw = require("netrw")
                -- Define key mappings for Netrw with descriptions
                --[[ vim.api.nvim_set_keymap('n', 'j', netrw.browse_updir(0), { buffer = true, silent = true, noremap = true, desc = "Move cursor down" })
        vim.keymap.set('n', 'k', netrw.browse_updir(1), { buffer = true, silent = true, noremap = true, desc = "Move cursor up" })
        vim.keymap.set('n', 'h', netrw.browse_updir(-1), { buffer = true, silent = true, noremap = true, desc = "Collapse directory" })
        vim.keymap.set('n', 'l', netrw.browse_dir("edit"), { buffer = true, silent = true, noremap = true, desc = "Expand directory or open file" })
        vim.keymap.set('n', 'o', netrw.browse_dir("explore"), { buffer = true, silent = true, noremap = true, desc = "Open directory or file in a new window" })
        vim.keymap.set('n', 'i', netrw.browse_dir("vsplit"), { buffer = true, silent = true, noremap = true, desc = "Open directory or file in a vertical split" })
        vim.keymap.set('n', 's', netrw.browse_dir("split"), { buffer = true, silent = true, noremap = true, desc = "Open directory or file in a horizontal split" })
        vim.keymap.set('n', 'P', netrw.browse_dir("updir"), { buffer = true, silent = true, noremap = true, desc = "Move to parent directory" })
        vim.keymap.set('n', 'gg', netrw.browse_dir("top"), { buffer = true, silent = true, noremap = true, desc = "Move to top of directory listing" })
        vim.keymap.set('n', 'G', netrw.browse_dir("bottom"), { buffer = true, silent = true, noremap = true, desc = "Move to bottom of directory listing" })

        vim.keymap.set('n', 'd', netrw.mkdir(), { buffer = true, silent = true, noremap = true, desc = "Create a new directory" })
        vim.keymap.set('n', 'D', netrw.del(), { buffer = true, silent = true, noremap = true, desc = "Delete file or directory" })
        vim.keymap.set('n', 'R', netrw.rename(), { buffer = true, silent = true, noremap = true, desc = "Rename file or directory" })
        vim.keymap.set('n', 'C', netrw.copy(), { buffer = true, silent = true, noremap = true, desc = "Copy file or directory" })
        vim.keymap.set('n', 'X', netrw.cut(), { buffer = true, silent = true, noremap = true, desc = "Cut file or directory" })

        vim.keymap.set('n', 'p', netrw.preview(), { buffer = true, silent = true, noremap = true, desc = "Preview file" })

        vim.keymap.set('n', 's', netrw.sort_size(), { buffer = true, silent = true, noremap = true, desc = "Sort files by size" })
        vim.keymap.set('n', 'o', netrw.sort_name(), { buffer = true, silent = true, noremap = true, desc = "Sort files by name" })
        vim.keymap.set('n', 'S', netrw.sort_time(), { buffer = true, silent = true, noremap = true, desc = "Sort files by time" })

        vim.keymap.set('n', 'I', netrw.toggle_hidden(), { buffer = true, silent = true, noremap = true, desc = "Toggle displaying hidden files" })
        vim.keymap.set('n', '*', netrw.mark(), { buffer = true, silent = true, noremap = true, desc = "Mark files for batch operations" })

        vim.keymap.set('n', '.', netrw.netrw_mark(), { buffer = true, silent = true, noremap = true, desc = "Toggle marking of files for batch commands" })
        vim.keymap.set('n', 'A', netrw.netrw_qf(), { buffer = true, silent = true, noremap = true, desc = "Execute batch file operations" })
        vim.keymap.set('n', 'Q', netrw.netrw_qf(), { buffer = true, silent = true, noremap = true, desc = "Execute batch file operations" })

        vim.keymap.set('n', 'm', netrw.menu(), { buffer = true, silent = true, noremap = true, desc = "Display menu for additional file operations" })
        vim.keymap.set('n', 'q', netrw.quit(), { buffer = true, silent = true, noremap = true, desc = "Quit Netrw" })
        vim.keymap.set('n', '?', netrw.help(), { buffer = true, silent = true, noremap = true, desc = "Display help" }) ]]

                -- vim.keymap.set('n', 'C', netrw.newfile, { buffer = true, silent = true, noremap = true, desc = "Create a new file" })
                -- vim.keymap.set('n', '^', netrw.ch_dir(), { buffer = true, silent = true, noremap = true, desc = "Change directory" })
                -- vim.keymap.set('n', 'o', netrw.vexplore(), { buffer = true, silent = true, noremap = true, desc = "Open directory listing in a vertical split" })
        end,
})


