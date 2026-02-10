local M = {}

function M.setup(style, utils)
    vim.opt.background = "dark"
    vim.o.winborder = "rounded"
    require("base16-colorscheme").with_config({
        telescope = true, indentblankline = true, notify = true, ts_rainbow = true,
        cmp = true, illuminate = true, dapui = true,
    })

    vim.cmd.colorscheme("base16-black-metal-immortal")
    local c = require("base16-colorscheme").colors
    -- c.base08 = "#5f7887"
    c.base08 = "#bfbfbf"
    require("base16-colorscheme").setup(c)
    c.bg = c.base00
    c.fg = c.base0C

    -- Override c with explicit palette from config
    c = {
        base00 = "#000000", base01 = "#121212", base02 = "#222222", base03 = "#333333",
        base04 = "#999999", base05 = "#c1c1c1", base06 = "#999999", base07 = "#c1c1c1",
        base08 = "#5f7887", base09 = "#aaaaaa", base0A = "#8c7f70", base0B = "#9b8d7f",
        base0C = "#aaaaaa", base0D = "#888888", base0E = "#999999", base0F = "#444444",
        bg = "#000000", fg = "#aaaaaa" 
    }

    utils.hl_overwrite({
        Normal = { bg = c.base00 },
        NormalFloat = { bg = nil },
        NormalNC = { bg = nil },
        SignColumn = { bg = nil },
        LineNr = { fg = c.base03, bg = c.base00 },
        CurosrLineNr = { link = "LineNr" },
        LineNrAbove = { link = "LineNr" },
        LineNrBelow = { link = "LineNr" },
        EndOfBuffer = { bg = nil, fg = c.base0F },

        TabLine = { bg = nil, fg = c.base03 },
        TabLineFill = { bg = nil, fg = nil },
        TabLineSel = { bg = c.base03, fg = c.fg },
        SnacksImageMath = { bg = nil, fg = c.fg },

        TSFuncBuiltin = { italic = false },
        TSVariableBuiltin = { italic = false },
        TSPunctDelimiter = { link = "TSType" },
        StatusLine = { fg = nil, bg = c.base01 },
        StatusLineNC = { fg = nil, bg = c.base01 },

        WhichKeyNormal = { bg = c.base01 },
        WhichKeyValue = { fg = c.base0D },

        SnacksPickerBorder = { fg = c.bg, bg = c.bg },
        SnacksPickerInput = { fg = c.fg, bg = c.base01 },
        SnacksPickerMatch = { link = "Type" },
        SnacksPickerInputBorder = { fg = c.base01, bg = c.base01 },
        SnacksPickerBoxBorder = { fg = c.base01, bg = c.base01 },
        SnacksPickerTitle = { fg = c.bg, bg = c.base08 },
        SnacksPickerBoxTitle = { fg = c.base01, bg = c.base08 },
        SnacksPickerList = { bg = c.base01 },
        SnacksPickerPrompt = { fg = c.base03, bg = c.base01 },
        SnacksPickerPreviewTitle = { fg = c.bg, bg = c.base01 },
        SnacksPickerPreview = { bg = c.bg },
        SnacksPickerToggle = { bg = c.base08, fg = c.bg },
        SnacksPickerDir = { fg = c.base0B },
        SnacksPickerSelected = { fg = c.fg },
        SnacksPickerListFooter = { bg = nil },

        BlinkCmpMenu = { link = "Normal" },
        BlinkCmpMenuBorder = { link = "Normal" },
        BlinkCmpKind = { link = "TSNamespace" },
        BlinkCmpLabelDetail = { link = "TSType" },
        BlinkCmpScrollBarThumb = { bg = c.fg },
        BlinkCmpSignatureHelpActiveParameter = { link = "Normal" },

        GitSignsAdd = { link = "GitSignsStagedAdd" },
        GitSignsDelete = { link = "GitSignsStagedDelete" },
        GitSignsChange = { link = "GitSignsStagedChange" },
        DiffAdd = { bg = utils.get_color("GitSignsStagedAdd", "fg"), fg = c.bg },
        DiffDelete = { bg = utils.get_color("GitSignsStagedDelete", "fg"), fg = c.bg },
        DiffText = { bg = utils.get_color("GitSignsStagedChange", "fg"), fg = c.bg, underline = false },
        DiffChange = { bg = c.bg, fg = c.fg },
        RenderMarkdownH1Bg = { bg = nil },
    })

    utils.hl_markdown_code(c.bg, c.base01)
    vim.api.nvim_set_hl(0, "StatusLineMain", { fg = "#DDDDDD", italic = false })
    vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#888888" })
end

return M
