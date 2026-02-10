local M = {}

function M.setup(style, utils)
    vim.o.winborder = "rounded"
    vim.opt.background = style

    -- 1. Setup the theme without the complex overrides first
    require("neomodern").setup({
        bg = "default",
        theme = "moon", -- 'moon' | 'iceclimber' | 'gyokuro' | 'hojicha' | 'roseprime'
        gutter = {
            cursorline = false,
            dark = false,
        },
        diagnostics = {
            darker = true,
            undercurl = true,
            background = true,
        },
        -- We remove the overrides from here to handle them safely below
    })

    -- 2. Load the theme (This creates the highlight groups)
    require("neomodern").load()

    -- 3. Now we can safely extract the colors from the loaded theme
    local c = {}
    c.bg = utils.get_color("Normal", "bg")
    c.fg = utils.get_color("Normal", "fg")
    c.alt = "#151515"
    c.line = utils.get_color("CursorLine", "bg")
    c.func = utils.get_color("Function", "fg")
    c.string = utils.get_color("String", "fg")
    c.operator = utils.get_color("Operator", "fg")
    c.constant = utils.get_color("Constant", "fg")
    c.warning = utils.get_color("@comment.warning", "fg") -- This works now!

    -- 4. Apply the highlights using your consistent utility
    utils.hl_overwrite({
        SnacksImageMath = { fg = c.constant, bg = c.bg },
        SnacksPickerBorder = { fg = c.bg, bg = c.bg },
        SnacksPickerInput = { fg = c.fg, bg = c.alt },
        SnacksPickerNormal = { fg = c.fg, bg = c.alt },
        SnacksPickerMatch = { fg = c.warning, bg = nil },
        SnacksPickerInputBorder = { fg = c.alt, bg = c.alt },
        SnacksPickerBoxBorder = { fg = c.alt, bg = c.alt },
        SnacksPickerTitle = { fg = c.bg, bg = c.operator },
        SnacksPickerBoxTitle = { fg = c.bg, bg = c.string },
        SnacksPickerListCursorLine = { fg = nil, bg = c.line },
        SnacksPickerList = { bg = c.alt, fg = c.fg },
        SnacksPickerPrompt = { fg = c.func, bg = c.alt },
        SnacksPickerPreviewTitle = { fg = c.bg, bg = c.func },
        SnacksPickerPreview = { bg = c.bg },
        SnacksPickerToggle = { bg = c.func, fg = c.bg },
        SnacksPickerDir = { fg = c.operator },
        SnacksPickerSelected = { link = "Type" },
        StatusLine = { fg = nil, bg = c.alt },
        StatusLineNC = { fg = nil, bg = c.alt },
        WinSeparator = { fg = c.fg, bg = nil },
        FloatBorder = { fg = c.fg, bg = nil },
    })

    vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.fg, italic = false })
    vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#777777" })
end

return M
