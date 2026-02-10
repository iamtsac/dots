local M = {}

function M.setup(style, utils)
    vim.o.winborder = "rounded"
    vim.opt.background = style
    local c = {
        bg = "#141415", pickerBg = "#1a1919", inactiveBg = "#1c1c24", fg = "#cdcdcd",
        floatBorder = "#878787", line = "#252530", comment = "#606079", builtin = "#b4d4cf",
        func = "#c48282", string = "#e8b589", number = "#e0a363", property = "#c3c3d5",
        constant = "#aeaed1", parameter = "#bb9dbd", visual = "#333738", error = "#d8647e",
        warning = "#f3be7c", hint = "#7e98e8", operator = "#90a0b5", keyword = "#6e94b2",
        type = "#9bb4bc", search = "#405065", plus = "#7fa563", delta = "#f3be7c",
    }

    require("vague").setup({
        transparent = false, bold = true, italic = true,
        style = {
            comments = "italic", keyword_return = "italic",
            builtin_constants = "bold", builtin_types = "bold",
        },
    })

    vim.cmd("colorscheme vague")
    
    if style == "dark" then
        utils.hl_overwrite({
            SnacksImageMath = { fg = c.bg, bg = c.fg },
            SnacksPickerBorder = { fg = c.bg, bg = c.bg },
            SnacksPickerInput = { fg = c.fg, bg = c.pickerBg },
            SnacksPickerNormal = { fg = c.fg, bg = c.pickerBg },
            SnacksPickerMatch = { fg = utils.get_color("@comment.warning", "fg"), bg = nil },
            SnacksPickerInputBorder = { fg = c.pickerBg, bg = c.pickerBg },
            SnacksPickerBoxBorder = { fg = c.pickerBg, bg = c.pickerBg },
            SnacksPickerTitle = { fg = c.bg, bg = c.string },
            SnacksPickerBoxTitle = { fg = c.bg, bg = c.plus },
            SnacksPickerListCursorLine = { fg = c.fg, bg = c.line },
            SnacksPickerList = { bg = c.pickerBg },
            SnacksPickerPrompt = { fg = c.func, bg = c.pickerBg },
            SnacksPickerPreviewTitle = { fg = c.bg, bg = c.func },
            SnacksPickerPreview = { bg = c.bg },
            SnacksPickerToggle = { bg = c.func, fg = c.bg },
            SnacksPickerDir = { fg = c.parameter },
            SnacksPickerSelected = { link = "Type" },
            StatusLine = { fg = nil, bg = c.pickerBg },
            StatusLineNC = { fg = nil, bg = c.pickerBg },
            CursorLine = { bg = c.line },
            LineNr = { fg = c.floatBorder, bg = c.bg },
        })
        vim.api.nvim_set_hl(0, "StatusLineMain", { fg = c.fg, italic = false })
        vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#777777" })
    end
end

return M
