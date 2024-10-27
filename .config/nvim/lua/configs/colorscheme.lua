vim.opt.background = "dark"
local c = require("oldworld.palette")
c.bg = "#131314"
require("oldworld").setup({
    terminal_colors = true, -- enable terminal colors
    styles = { -- You can pass the style using the format: style = true
        comments = {}, -- style for comments
        keywords = {}, -- style for keywords
        identifiers = {}, -- style for identifiers
        functions = {italic=true, bold=true}, -- style for functions
        variables = {bold=true}, -- style for variables
        booleans = {}, -- style for booleans
    },
    integrations = { -- You can disable/enable integrations
        alpha = true,
        cmp = true,
        flash = true,
        gitsigns = true,
        hop = false,
        indent_blankline = true,
        lazy = true,
        lsp = true,
        markdown = true,
        mason = true,
        navic = false,
        neo_tree = false,
        neorg = true,
        noice = true,
        notify = true,
        rainbow_delimiters = true,
        telescope = true,
        treesitter = true,
    },

    highlight_overrides = {
        TelescopeBorder = { fg = c.bg, bg = c.bg },
        TelescopeNormal = { fg = c.fg, bg = c.bg },
        TelescopePreviewTitle = { fg = c.black, bg = c.green, bold = true },
        TelescopeResultsTitle = { fg = c.bg, bg = c.bg },
        TelescopePromptTitle = { fg = c.black, bg = c.cyan, bold = true },
        TelescopePromptBorder = { fg = c.gray01, bg = c.gray01 },
        TelescopePromptNormal = { fg = c.gray06, bg = c.gray01 },
        TelescopePromptCounter = { fg = c.gray04, bg = c.gray01 },
        TelescopeMatching = { fg = c.yellow, underline = true },
    }
})


vim.cmd.colorscheme("oldworld")
