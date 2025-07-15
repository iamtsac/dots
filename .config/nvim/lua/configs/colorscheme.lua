local hl_overwrite = function(hls)
    for k, v in pairs(hls) do
        vim.api.nvim_set_hl(0, k, v)
    end
end

local function get_color(group, attr)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

local function read_style(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end
    local variant = file:read("*l") -- read one line
    file:close()
    return variant
end
local theme_variant = read_style(os.getenv("HOME") .. "/.config/style")

-- local current_theme = "black-metal-gorgoroth"
local current_theme = "kanso"

if current_theme == "oldworld" then
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
        BlinkCmpMenu = { link = "Normal" },
        BlinkCmpMenuBorder = { link = "Normal" },

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
    vim.api.nvim_set_hl(0, "StatusLineMain", { fg = "#DDDDDD", italic = false })
    vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#888888" })
elseif current_theme == "black-metal-gorgoroth" then
    vim.opt.background = "dark"
    vim.o.winborder = "rounded"
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

    c = {
        base00 = "#000000",
        base01 = "#121212",
        base02 = "#222222",
        base03 = "#333333",
        base04 = "#999999",
        base05 = "#c1c1c1",
        base06 = "#999999",
        base07 = "#c1c1c1",
        base08 = "#5f7887",
        base09 = "#aaaaaa",
        base0A = "#8c7f70",
        base0B = "#9b8d7f",
        base0C = "#aaaaaa",
        base0D = "#888888",
        base0E = "#999999",
        base0F = "#444444",
    }

    hl_overwrite({
        Normal = { bg = c.base00 },
        NormalFloat = { bg = nil },
        NormalNC = { bg = nil },
        SignColumn = { bg = nil },
        LineNr = { fg = c.base03, bg = c.base00 },
        CurosrLineNr = { link = "LineNr" },
        LineNrAbove = { link = "LineNr" },
        LineNrBelow = { link = "LineNr" },
        EndOfBuffer = { bg = nil, fg = c.base0F },

        RenderMarkdownCode = { bg = nil },
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

        BlinkCmpMenu = { link = "Normal" },
        BlinkCmpMenuBorder = { link = "Normal" },
        BlinkCmpKind = { link = "TSNamespace" },
        BlinkCmpLabelDetail = { link = "TSType" },
        BlinkCmpScrollBarThumb = { bg = c.fg },
        BlinkCmpSignatureHelpActiveParameter = { link = "Normal" },

        GitSignsAdd = { link = "GitSignsStagedAdd" },
        GitSignsDelete = { link = "GitSignsStagedDelete" },
        GitSignsChange = { link = "GitSignsStagedChange" },
        DiffAdd = { bg = get_color("GitSignsStagedAdd", "fg"), fg = c.bg },
        DiffDelete = { bg = get_color("GitSignsStagedDelete", "fg"), fg = c.bg },
        DiffText = { bg = get_color("GitSignsStagedChange", "fg"), fg = c.bg, underline = false },
        DiffChange = { bg = c.bg, fg = c.fg },
        RenderMarkdownH1Bg = { bg = nil },
    })

    vim.api.nvim_create_augroup("MarkdownEvent", { clear = true })

    vim.api.nvim_create_autocmd("BufEnter", {
        group = "MarkdownEvent",
        pattern = "*.md",
        callback = function()
            hl_overwrite({
                RenderMarkdownCode = { bg = "#121212" },
            })
        end,
    })

    vim.api.nvim_create_autocmd("BufLeave", {
        group = "MarkdownEvent",
        pattern = "*.md",
        callback = function()
            hl_overwrite({
                RenderMarkdownCode = { bg = nil },
            })
        end,
    })
    vim.api.nvim_set_hl(0, "StatusLineMain", { fg = "#DDDDDD", italic = false })
    vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#888888" })
elseif current_theme == "kanso" then
    vim.o.winborder = "rounded"
    vim.opt.background = theme_variant
    require("kanso").setup({
        bold = true, -- enable bold fonts
        italics = false, -- enable italics
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = false },
        statementStyle = {},
        typeStyle = {},
        transparent = true, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        theme = "zen", -- Load "zen" theme
        background = { -- map the value of 'background' option to a theme
            dark = "zen", -- try "ink" !
            light = "pearl", -- try "mist" !
        },
    })
    local c = {
        springViolet1 = "#938AA9",
        springGreen = "#98BB6C",
        zenRed = "#E46876",
        pearlWhite1 = "#e2e1df",
        pearlWhite2 = "#dddddb",
        pearlViolet4 = "#624c83",
        gray0 = "#111111",
        gray2 = "#181818",
        gray3 = "#282828",
    }

    -- setup must be called before loading
    vim.cmd("colorscheme kanso")
    c.fg = get_color("Normal", "fg")
    c.bg = nil
    if theme_variant == "dark" then
        hl_overwrite({
            SnacksPickerBorder = { fg = c.bg, bg = c.bg },
            SnacksPickerInput = { fg = c.fg, bg = c.gray0 },
            SnacksPickerNormal = { fg = c.fg, bg = c.gray0 },
            SnacksPickerMatch = { link = "Type" },
            SnacksPickerInputBorder = { fg = c.gray0, bg = c.gray0 },
            SnacksPickerBoxBorder = { fg = c.gray0, bg = c.gray0 },
            SnacksPickerTitle = { fg = c.bg, bg = c.springGreen },
            SnacksPickerBoxTitle = { fg = c.gray0, bg = c.springGreen },
            SnacksPickerList = { bg = c.gray0 },
            SnacksPickerPrompt = { fg = c.zenRed, bg = c.gray0 },
            SnacksPickerPreviewTitle = { fg = c.bg, bg = c.zenRed },
            SnacksPickerPreview = { bg = c.bg },
            SnacksPickerToggle = { bg = c.springGreen, fg = c.bg },
            SnacksPickerDir = { fg = c.springViolet1 },

            StatusLine = { fg = nil, bg = c.gray2 },
            CursorLine = { fg = nil, bg = c.gray2 },
            StatusLineNC = { fg = nil, bg = c.gray2 },

            Normal = { bg = nil },
            NormalFloat = { bg = nil },
            NormalNC = { bg = nil },
            SignColumn = { bg = nil },

            BlinkCmpMenu = { link = "Normal" },
            BlinkCmpScrollBarThumb = { bg = c.fg },
            BlinkCmpMenuSelection = { bg = c.gray3 },
            BlinkCmpSignatureHelpActiveParameter = { link = "Normal" },
            RenderMarkdownCode = { bg = "#000000" },
        })

        vim.api.nvim_create_augroup("MarkdownEvent", { clear = true })

        vim.api.nvim_create_autocmd("BufEnter", {
            group = "MarkdownEvent",
            pattern = "*.md",
            callback = function()
                hl_overwrite({
                    RenderMarkdownCode = { bg = c.gray2 },
                })
            end,
        })

        vim.api.nvim_create_autocmd("BufLeave", {
            group = "MarkdownEvent",
            pattern = "*.md",
            callback = function()
                hl_overwrite({
                    RenderMarkdownCode = { bg = "#000000" },
                })
            end,
        })

        vim.api.nvim_set_hl(0, "StatusLineMain", { fg = "#DDDDDD", italic = false })
        vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#888888" })
    elseif theme_variant == "light" then
        hl_overwrite({
            SnacksImageMath = { fg = c.fg, bg = c.bg },
            SnacksPickerBorder = { fg = c.bg, bg = c.bg },
            SnacksPickerInput = { fg = c.fg, bg = c.pearlWhite1 },
            SnacksPickerNormal = { fg = c.fg, bg = c.pearlWhite1 },
            SnacksPickerMatch = { link = "Boolean" },
            SnacksPickerInputBorder = { fg = c.pearlWhite1, bg = c.pearlWhite1 },
            SnacksPickerBoxBorder = { fg = c.pearlWhite1, bg = c.pearlWhite1 },
            SnacksPickerTitle = { fg = c.bg, bg = c.springGreen },
            SnacksPickerBoxTitle = { fg = c.gray0, bg = c.springGreen },
            SnacksPickerListCursorLine = { fg = c.gray0, bg = c.pearlYellow4 },
            SnacksPickerList = { bg = c.pearlWhite1 },
            SnacksPickerPrompt = { fg = c.zenRed, bg = c.pearlWhite1 },
            SnacksPickerPreviewTitle = { fg = c.bg, bg = c.zenRed },
            SnacksPickerPreview = { bg = c.bg },
            SnacksPickerToggle = { bg = c.springGreen, fg = c.bg },
            SnacksPickerDir = { fg = c.pearlViolet4 },
            StatusLine = { fg = nil, bg = c.pearlWhite1 },
            StatusLineNC = { fg = nil, bg = c.pearlWhite1 },
            RenderMarkdownCode = { bg = "#EEEEEE" },
        })

        vim.api.nvim_create_augroup("MarkdownEvent", { clear = true })

        vim.api.nvim_create_autocmd("BufEnter", {
            group = "MarkdownEvent",
            pattern = "*.md",
            callback = function()
                hl_overwrite({
                    RenderMarkdownCode = { bg = c.pearlWhite2 },
                })
            end,
        })

        vim.api.nvim_create_autocmd("BufLeave", {
            group = "MarkdownEvent",
            pattern = "*.md",
            callback = function()
                hl_overwrite({
                    RenderMarkdownCode = { bg = "#EEEEEE" },
                })
            end,
        })

        vim.api.nvim_set_hl(0, "StatusLineMain", { fg = "#000000", italic = false })
        vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#777777" })
    end
end
