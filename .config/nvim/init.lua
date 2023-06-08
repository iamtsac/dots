vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"
vim.opt.mouse = "a"
vim.opt.backspace = "indent,eol,start"
vim.opt.updatetime = 1000
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hidden = true
vim.opt.clipboard = "unnamedplus"
vim.opt.showcmd = false
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.autoread = true
vim.opt.backup = false
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.writebackup = false
vim.opt.cmdheight = 0

-- window-local options
vim.wo.number = true
vim.wo.numberwidth = 1
vim.wo.signcolumn = "yes:1"

-- buffer-local options
vim.bo.ai = true
vim.bo.si = true
vim.bo.expandtab = true
vim.bo.tabstop = 8
vim.bo.softtabstop = 4
vim.bo.cindent = true
vim.bo.swapfile = false
vim.bo.textwidth = 80
vim.bo.swapfile = false

-- global variables
vim.g.mapleader = " " -- g -> let g:...
vim.opt.list = true
vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 20

vim.opt.completeopt = {"menu", "menuone", "noselect"}

require("custom")
vim.cmd [[ colorscheme carbonfox ]]
vim.opt.laststatus = 0
