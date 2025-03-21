vim.opt.background = "dark"
local c = require("oldworld.palette")
c.bg = "#131314"
require("oldworld").setup({
    terminal_colors = true, -- enable terminal colors
    styles = { -- You can pass the style using the format: style = true
        comments = { italic = true }, -- style for comments
        keywords = {}, -- style for keywords
        identifiers = {}, -- style for identifiers
        functions = { italic = false, bold = false }, -- style for functions
        variables = { bold = false }, -- style for variables
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
        -- Normal = { bg = nil },
        NormalFloat = { bg = nil },
        SignColumn = { bg = nil },
        TelescopeBorder = { fg = c.bg, bg = c.bg },
        TelescopeNormal = { fg = c.fg, bg = c.bg },
        TelescopePreviewTitle = { fg = c.black, bg = c.green, bold = true },
        TelescopeResultsTitle = { fg = c.bg, bg = c.bg },
        TelescopePromptTitle = { fg = c.black, bg = c.cyan, bold = true },
        TelescopePromptBorder = { fg = c.gray01, bg = c.gray01 },
        TelescopePromptNormal = { fg = c.gray06, bg = c.gray01 },
        TelescopePromptCounter = { fg = c.gray04, bg = c.gray01 },
        TelescopeMatching = { fg = c.yellow, underline = true },

        SnacksPickerBorder = { fg = c.background, bg = c.background },
        SnacksPickerInput = { fg = c.foreground, bg = c.gray0 },
        SnacksPickerInputBorder = { fg = c.gray0, bg = c.gray0 },
        SnacksPickerBoxBorder = { fg = c.gray0, bg = c.gray0 },
        SnacksPickerTitle = { fg = c.background, bg = c.green },
        SnacksPickerBoxTitle = { fg = c.gray0, bg = c.green },
        SnacksPickerList = { bg = c.gray0 },
        SnacksPickerPrompt = { fg = c.red, bg = c.gray0 },
        SnacksPickerPreviewTitle = { fg = c.background, bg = c.red },
        SnacksPickerPreview = { bg = c.background },
        SnacksPickerToggle = { bg = c.green, fg = c.background },
    },
})
--
-- require("jellybeans").setup({
--     style = "dark", -- "dark" or "light"
--     transparent = false,
--     italics = false,
--     flat_ui = true, -- toggles "flat UI" for pickers
--     plugins = {
--         all = false,
--         auto = true, -- will read lazy.nvim and apply the colors for plugins that are installed
--     },
--     on_highlights = function(hl, c)
--         -- hl.Constant = { fg = "#00ff00", bold = true }
--         -- hl.InclineNormal = { bg = "#00ff00", bold = true }
--     end,
--     on_colors = function(c)
--         -- local light_bg = "#ffffff"
--         -- local dark_bg = nil
--         c.background = dark_bg
--         c.float_bg = c.background
--         c.mine_shaft = "#1b1b1b"
--     end,
-- })

vim.cmd.colorscheme("oldworld")
