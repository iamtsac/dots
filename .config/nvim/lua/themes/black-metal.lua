local M = {}

function M.setup(style, variant, utils)
    vim.opt.background = "dark"
    vim.o.winborder = "rounded"
    require("base16-colorscheme").with_config({
        telescope = true, indentblankline = true, notify = true, ts_rainbow = true,
        cmp = true, illuminate = true, dapui = true,
    })

    vim.print(variant)
    vim.cmd.colorscheme("base16-black-metal" .. (variant == "default" and "" or "-" .. variant))
    local c = require("base16-colorscheme").colors
    -- c.base08 = "#bfbfbf"
    c.base08 = utils.color_changer.lighten(c.base0C, 0.8)
    require("base16-colorscheme").setup(c)
    vim.schedule(function()
        c.bg = c.base00
        c.fg = c.base0C

        utils.hl_overwrite({
            Normal = { bg = c.base00 },
            NormalFloat = { bg = "none" },
            NormalNC = { bg = "none" },
            SignColumn = { bg = "none" },
            LineNr = { fg = c.base03, bg = c.base00 },
            CurosrLineNr = { link = "LineNr" },
            LineNrAbove = { link = "LineNr" },
            LineNrBelow = { link = "LineNr" },
            EndOfBuffer = { bg = "none", fg = c.base0F },

            TabLine = { bg = "none", fg = c.base03 },
            TabLineFill = { bg = "none", fg = "none" },
            TabLineSel = { bg = c.base03, fg = c.fg },
            SnacksImageMath = { bg = "none", fg = c.fg },

            TSFuncBuiltin = { italic = false },
            TSVariableBuiltin = { italic = false },
            TSPunctDelimiter = { link = "TSType" },
            StatusLine = { fg = "none", bg = utils.color_changer.lighten(c.base01, 0.03) },
            StatusLineNC = { fg = "none", bg = utils.color_changer.lighten(c.base01, 0.03) },

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
            SnacksPickerListFooter = { bg = "none" },
            Directory = { bg = "none" },

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
            -- RenderMarkdownH1Bg = { bg = "none" },
        })

        -- utils.hl_markdown_code(c.bg, c.base01)
        vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.base08, italic = false })
        vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = utils.color_changer.darken(c.fg, 0.05) })
    end)
end

return M
