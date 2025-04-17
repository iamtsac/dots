local hl_overwrite = function(hls)
    for k, v in pairs(hls) do
        vim.api.nvim_set_hl(0, k, v)
    end
end

local function get_color(group, attr)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

local current_theme = "black-metal-gorgoroth"

vim.opt.background = "dark"

if current_theme == "oldworld" then
    local c = require("oldworld.palette")
    c.bg = "#0D0D0D"
    c.fg = "#DDDDDD"
    require("oldworld").setup({
        terminal_colors = true,
        styles = {
            comments = { italic = true, bold = true },
            keywords = {},
            identifiers = {},
            functions = { italic = false, bold = false },
            variables = { bold = true },
            booleans = {},
        },
        integrations = {
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

        highlight_overrides = {},
    })

    vim.cmd.colorscheme("oldworld")

    hl_overwrite({
        Normal = { bg = nil },
        NormalFloat = { bg = nil },
        NormalNC = { bg = nil },
        SignColumn = { bg = nil },
        LineNr = { fg = "#999999" },
        EndOfBuffer = { link = "LineNr" },

        TabLine = { bg = c.gray2, fg = c.fg },
        TabLineFill = { bg = nil, fg = nil },
        TabLineSel = { bg = c.blue, fg = c.bg },
        ["@module.python"] = { link = "Type" },
        ["@constructor"] = { link = "@variable" },

        SnacksImageMath = { bg = nil, fg = c.fg },
        SnacksPickerBorder = { fg = c.bg, bg = c.bg },
        SnacksPickerInput = { fg = c.fg, bg = c.gray0 },
        SnacksPickerMatch = { link = "Type" },
        SnacksPickerInputBorder = { fg = c.gray0, bg = c.gray0 },
        SnacksPickerBoxBorder = { fg = c.gray0, bg = c.gray0 },
        SnacksPickerTitle = { fg = c.bg, bg = c.green },
        SnacksPickerBoxTitle = { fg = c.gray0, bg = c.green },
        SnacksPickerList = { bg = c.gray0 },
        SnacksPickerPrompt = { fg = c.red, bg = c.gray0 },
        SnacksPickerPreviewTitle = { fg = c.bg, bg = c.red },
        SnacksPickerPreview = { bg = c.bg },
        SnacksPickerToggle = { bg = c.green, fg = c.bg },
        SnacksPickerDir = { fg = c.purple },
    })
end

if current_theme == "black-metal-gorgoroth" then
    require("base16-colorscheme").with_config({
        telescope = true,
        indentblankline = true,
        notify = true,
        ts_rainbow = true,
        cmp = true,
        illuminate = true,
        dapui = true,
    })

    vim.cmd.colorscheme("base16-black-metal-gorgoroth")
    local c = require("base16-colorscheme").colors
    c.base08 = "#5f7887"
    require("base16-colorscheme").setup(c)
    c.bg = c.base00
    c.fg = c.base0C
    c.gray0 = c.base01
    c.gray1 = c.base02
    c.gray2 = c.base03
    c.gray3 = c.base0D
    c.gray4 = c.base04
    c.blue = c.base08
    c.dark_yellow = c.base0B

    hl_overwrite({
        Normal = { bg = nil },
        NormalFloat = { bg = nil },
        NormalNC = { bg = nil },
        SignColumn = { bg = nil },
        LineNr = { fg = c.base0C },
        EndOfBuffer = { link = "LineNr" },

        TabLine = { bg = nil, fg = c.gray2 },
        TabLineFill = { bg = nil, fg = nil },
        TabLineSel = { bg = c.gray2, fg = c.fg },
        SnacksImageMath = { bg = nil, fg = c.fg },

        TSPunctDelimiter = { link = "TSParameter" },
        StatusLine = { fg = nil, bg = c.gray0 },
        StatusLineNC = { fg = nil, bg = c.gray0 },

        WhichKeyNormal = { bg = c.gray0 },
        WhichKeyValue = { fg = c.gray3 },

        SnacksPickerBorder = { fg = c.bg, bg = c.bg },
        SnacksPickerInput = { fg = c.fg, bg = c.gray0 },
        SnacksPickerMatch = { link = "Type" },
        SnacksPickerInputBorder = { fg = c.gray0, bg = c.gray0 },
        SnacksPickerBoxBorder = { fg = c.gray0, bg = c.gray0 },
        SnacksPickerTitle = { fg = c.bg, bg = c.blue },
        SnacksPickerBoxTitle = { fg = c.gray0, bg = c.blue },
        SnacksPickerList = { bg = c.gray0 },
        SnacksPickerPrompt = { fg = c.gray2, bg = c.gray0 },
        SnacksPickerPreviewTitle = { fg = c.bg, bg = c.gray0 },
        SnacksPickerPreview = { bg = c.bg },
        SnacksPickerToggle = { bg = c.blue, fg = c.bg },
        SnacksPickerDir = { fg = c.dark_yellow },
    })
end
