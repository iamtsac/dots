local M = {}

function M.setup(style, variant, utils)
    vim.opt.background = "dark"
    vim.o.winborder = "rounded"
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
            alpha = true, cmp = true, flash = true, gitsigns = true,
            hop = false, indent_blankline = true, lazy = true, lsp = true,
            markdown = true, mason = true, navic = false, neo_tree = false,
            neorg = true, noice = true, notify = true, rainbow_delimiters = true,
            telescope = true, treesitter = true,
        },
        highlight_overrides = {},
    })

    vim.cmd.colorscheme("oldworld")

    vim.schedule(function()
        utils.hl_overwrite({
            NormalFloat = { bg = c.bg },
            NormalNC = { bg = c.bg },
            SignColumn = { bg = c.bg },
            LineNr = { fg = utils.color_changer.darken(c.fg, 0.7) },
            EndOfBuffer = { link = "LineNr" },
            BlinkCmpMenu = { link = "Normal" },
            BlinkCmpMenuBorder = { link = "Normal" },

            TabLine = { bg = c.gray2, fg = c.fg },
            TabLineFill = { bg = "none", fg = "none" },
            TabLineSel = { bg = c.blue, fg = c.bg },
            ["@module.python"] = { link = "Type" },
            ["@constructor"] = { link = "@variable" },

            SnacksImageMath = { bg = "none", fg = c.fg },
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
            Directory = { bg = "none" },
            SnacksPickerToggle = { bg = c.green, fg = c.bg },
            SnacksPickerDir = { fg = c.purple },
            TreesitterContextBottom = { underline=true },
            TreesitterContextLineNumberBottom = { underline=true },
        })
        
        -- utils.hl_markdown_code(c.bg, c.gray1)
        vim.api.nvim_set_hl(0, "StatusLineMain", { fg = "#DDDDDD", italic = false })
        vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#888888" })
    end)
end

return M
