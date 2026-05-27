local M = {}

function M.setup(style, variant, utils)
    vim.opt.background = "dark"
    vim.o.winborder = "rounded"
    local bm = require("black-metal")

    bm.setup({
        theme = variant,
        variant = "dark",
        alt_bg = false,
        colored_docstrings = true,
        cursorline_gutter = true,
        dark_gutter = false,
        favor_treesitter_hl = true,
        plain_float = false,
        show_eob = true,
        term_colors = true,
        transparent = false,

        diagnostics = {
            darker = true,
            undercurl = true,
            background = true,
        },
        code_style = {
            comments = "italic",
            conditionals = "none",
            functions = "none",
            keywords = "none",
            headings = "bold",
            operators = "none",
            keyword_return = "none",
            strings = "none",
            variables = "none",
        },
        plugin = {
            cmp = { plain = false, reverse = false }, 
        },
    })

    bm.load()
    local c = require("black-metal.palette")[variant]

    vim.schedule(function()
        c.bg = utils.get_color("Normal", "bg")
        c.fg = utils.get_color("Normal", "fg")
        c.string = utils.get_color("String", "fg")

        c.fg_unselected = utils.color_changer.darken(c.fg, 0.55)
        c.bg_lighter = utils.color_changer.lighten(c.bg, 0.03)
        c.bg_unselected = utils.color_changer.lighten(c.bg, 0.07)
        c.fg_selected = c.fg
        c.bg_selected = c.bg_unselected
        c.bg_tabbar = c.bg_unselected
        c.fg_indicator = c.string
        c.fg_border = c.bg_tabbar

        utils.hl_overwrite({
            Normal = { bg = c.bg },
            NormalFloat = { link = "Normal" },
            SignColumn = { bg = "none" },
            LineNr = { fg = c.fg_unselected, bg = "none" },
            CurosrLineNr = { link = "LineNr" },
            LineNrAbove = { link = "LineNr" },
            LineNrBelow = { link = "LineNr" },
            EndOfBuffer = { bg = "none", fg = c.bg },

            TabLine = { bg = "none", fg = c.fg_unselected },
            TabLineFill = { bg = c.bg_tabbar, fg = "none" },
            TabLineSel = { bg = c.bg_selected, fg = c.fg_selected },
            SnacksImageMath = { bg = "none", fg = c.fg },

            TSFuncBuiltin = { italic = false },
            TSVariableBuiltin = { italic = false },
            TSPunctDelimiter = { link = "TSType" },
            StatusLine = { fg = "none", bg = c.bg_tabbar },
            StatusLineNC = { fg = "none", bg = c.bg_tabbar },

            WhichKeyNormal = { bg = c.bg },
            WhichKeyValue = { fg = c.fg },

            SnacksPickerBorder = { fg = c.bg, bg = c.bg },
            SnacksPickerInput = { fg = c.fg, bg = c.bg_lighter },
            SnacksPickerMatch = { link = "Type" },
            SnacksPickerInputBorder = { fg = c.bg_lighter, bg = c.bg_lighter },
            SnacksPickerBoxBorder = { fg = c.bg_lighter, bg = c.bg_lighter },
            SnacksPickerTitle = { fg = c.bg, bg = c.bg_lighter },
            SnacksPickerBoxTitle = { fg = c.bg_lighter, bg = c.bg },
            SnacksPickerList = { bg = c.bg_lighter },
            SnacksPickerPrompt = { bg = c.bg_lighter },
            SnacksPickerPreviewTitle = { fg = c.bg, bg = c.bg_lighter },
            SnacksPickerPreview = { bg = c.bg },
            SnacksPickerToggle = { bg = c.bg_lighter, fg = c.bg },
            SnacksPickerDir = { fg = c.string },
            SnacksPickerSelected = { fg = c.fg },
            SnacksPickerListFooter = { bg = "none" },
            Directory = { bg = "none" },

            BlinkCmpMenu = { link = "Normal" },
            BlinkCmpMenuBorder = { link = "Normal" },
            BlinkCmpKind = { link = "TSNamespace" },
            BlinkCmpLabelDetail = { link = "TSType" },
            BlinkCmpScrollBarThumb = { bg = c.fg },
            BlinkCmpSignatureHelpActiveParameter = { link = "Normal" },
            WinSeparator = { fg = c.fg_unselected, bg = "none" },

            TreesitterContext = { link="Normal" },
            TreesitterContextLineNumber = { link="LineNr" },
            TreesitterContextSeparator = { link="Comment" },
            TabLineFill = { bg = c.bg_tabbar },
            TabLineSel = { bg = c.bg_selected, fg = c.fg_selected },
            TabLine = { bg = c.bg_unselected, fg = c.fg_unselected },
            TabLineIndicator = { bg = c.bg_tabbar, fg = c.fg_indicator },

            FloatingTabsActive = { fg = c.fg_selected, bg = c.bg_selected },
            FloatingTabsInactive = { fg = c.fg_unselected, bg = c.bg_unselected },
            FloatingTabsIndicator = { fg = c.fg_indicator, bg = c.bg_tabbar },
            FloatingTabsBorder = { fg = c.fg_border, bg = "NONE" },
            FloatingTabsSeparator = { fg = c.fg_indicator, bg = c.bg_tabbar },

            StatusLineMain = { fg = c.fg, italic = false },
            StatusLineSecondary = { fg = utils.color_changer.darken(c.fg, 0.35) },
        })
    end)
end

return M
