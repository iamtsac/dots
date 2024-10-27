vim.opt.background = "dark"
vim.g.mellow_italic_functions = true
vim.g.mellow_bold_functions = true
local variants = require("mellow.colors")
local cfg = require("mellow.config").config
local c = variants[cfg.variant]
c.bg = "#131314"
vim.cmd.colorscheme("mellow")
