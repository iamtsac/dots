-- vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"
vim.opt.mouse = "a"
vim.opt.backspace = "indent,eol,start"
vim.opt.updatetime = 1000
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hidden = true
vim.opt.clipboard = "unnamedplus"
vim.opt.showcmd = true
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.autoread = true
vim.opt.backup = false
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.writebackup = false
vim.opt.cmdheight = 1
vim.opt.laststatus = 0
vim.opt.tabstop = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = false

-- window-local options
vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.numberwidth = 1
vim.wo.signcolumn = "auto"
vim.wo.wrap = false

-- buffer-local options
vim.bo.ai = true
vim.bo.si = true
vim.bo.textwidth = 0
vim.bo.swapfile = false

-- global variables
vim.opt.list = true
vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 20

vim.opt.completeopt = { "menu", "menuone", "noselect" }

require("core/plugins")
require("configs/treesitter")

require("configs/colorscheme")
require("configs/incline")
require("configs/highlights")
require("configs/gitsigns")
require("configs/comment")
require("configs/harpoon")
require("configs/mason")
require("configs/conform")
require("configs/oil")
require("configs/snacks")
require("core/keymaps")
