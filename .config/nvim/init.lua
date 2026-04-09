-- vim.g.loaded_netrw = 1
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.g.loaded_netrwPlugin = 1
vim.o.termguicolors = true
vim.o.encoding = "utf-8"
vim.o.mouse = "a"
vim.o.backspace = "indent,eol,start"
vim.o.updatetime = 1000
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hidden = true
vim.o.clipboard = "unnamedplus"
vim.o.showcmd = true
vim.o.errorbells = false
vim.o.visualbell = false
vim.o.autoread = true
vim.o.backup = false
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 0
vim.o.writebackup = false
vim.o.cmdheight = 1
vim.o.showcmd = true
vim.o.showcmdloc = "statusline"
vim.o.showmode = false
vim.o.laststatus = 3
vim.o.tabstop = 8
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.cursorline = true
vim.o.cursorlineopt = "line"
vim.opt.fillchars = {
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┫",
    vertright = "┣",
    verthoriz = "╋",
}

-- window-local options
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.numberwidth = 4
vim.wo.signcolumn = "yes:2"
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
vim.g.mapleader = " "

require("core/plugins")
require("configs/treesitter")
require("configs/snacks")

require("configs/gitsigns")
require("configs/mason")
require("configs/conform")
require("configs/oil")
require("core/keymaps")
require("configs/comment")
require("configs/tabline")
require("configs/statusline")
require("configs/markdown")
require("configs/lsp")
require("configs/overseer")

local theme_utils = require("utils.theme")
theme_utils.load_theme()

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum"

vim.g.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "tex", "plaintex", "markdown", "typst" },
    callback = function()
        vim.opt_local.textwidth = 120
        vim.opt_local.formatoptions:append("t")
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
    end,
})

local uv = vim.loop
local stylerc = vim.fn.expand("~/.config/stylerc")
local handle = vim.uv.new_fs_event()

local function watch_theme()
    handle:start(
        stylerc,
        {},
        vim.schedule_wrap(function(err, filename, events)
            if err then
                vim.notify("Theme watcher error: " .. err, vim.log.levels.ERROR)
                return
            end
            if events.change then
                theme_utils.load_theme()
            end
        end)
    )
end
watch_theme()
