local M = {}

function M.setup(style, variant, utils)
    vim.o.winborder = "rounded"
    vim.opt.background = style
    local koda = require("koda")
    koda.setup({
        transparent = false, auto = true, cache = true,
        styles = { functions = { bold = true }, keywords = {}, comments = {}, strings = {}, constants = {} },
        colors = {
            bg = "#101010", fg = "#b0b0b0", dim = "#000000", line = "#272727",
            keyword = "#777777", comment = "#50585d", border = "#ffffff", emphasis = "#ffffff",
            func = "#ffffff", string = "#ffffff", char = "#ffffff", const = "#d9ba73",
            highlight = "#458ee6", info = "#8ebeec", success = "#86cd82", warning = "#d9ba73",
            danger = "#ff7676", green = "#14ba19", orange = "#f54d27", red = "#701516",
            pink = "#f2a4db", cyan = "#5abfb5",
        },
    })

    vim.cmd("colorscheme koda")
    vim.schedule(function()
        local c = koda.get_palette()
        c.pickerbg = utils.color_changer.lighten(c.bg, 0.03)

        if style == "dark" then
            utils.hl_overwrite({
                SnacksImageMath = { fg = c.emphasis, bg = c.bg },
                SnacksPickerBorder = { fg = c.bg, bg = c.bg },
                SnacksPickerInput = { fg = c.fg, bg = c.pickerbg },
                SnacksPickerNormal = { fg = c.fg, bg = c.pickerbg },
                SnacksPickerMatch = { fg = utils.get_color("@comment.warning", "fg"), bg = "none" },
                SnacksPickerInputBorder = { fg = c.pickerbg, bg = c.pickerbg },
                NormalFloat = { bg = "none" },
                LineNr = { bg = "none" },
                Directory = { bg = "none" },
                SnacksPickerBoxBorder = { fg = c.pickerbg, bg = c.pickerbg },
                SnacksPickerTitle = { fg = c.bg, bg = c.orange },
                SnacksPickerBoxTitle = { fg = c.bg, bg = c.green },
                SnacksPickerListCursorLine = { fg = "none", bg = c.line },
                SnacksPickerList = { bg = c.pickerbg, fg = c.emphasis },
                SnacksPickerPrompt = { fg = c.func, bg = c.pickerbg },
                SnacksPickerPreviewTitle = { fg = c.bg, bg = c.func },
                SnacksPickerPreview = { bg = c.bg },
                SnacksPickerToggle = { bg = c.func, fg = c.bg },
                SnacksPickerDir = { fg = c.fg },
                SnacksPickerSelected = { link = "Type" },
                StatusLine = { fg = "none", bg = c.pickerbg },
                StatusLineNC = { fg = "none", bg = c.pickerbg },
                CursorLine = { bg = c.pickerbg },
                WinSeparator = { fg = c.fg, bg = "none" },
                TreesitterContext = { link="Normal" },
                TreesitterContextLineNumber = { link="LineNr" },
                TreesitterContextSeparator = { link="Comment" },
                -- RenderMarkdownCode = { bg = c.bg },
            })
            vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.fg, italic = false })
            vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#777777" })
            -- utils.hl_markdown_code(c.bg, c.dim)
        end
    end)
end

return M
