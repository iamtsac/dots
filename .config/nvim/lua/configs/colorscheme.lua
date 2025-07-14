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
  if not file then return nil end
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
        -- Bg Shades
        zen0 = "#090E13",
        zen1 = "#1C1E25",
        zen2 = "#22262D",
        zen3 = "#393B44",

        -- Popup and Floats
        zenBlue1 = "#223249",
        zenBlue2 = "#2D4F67",

        -- Diff and Git
        winterGreen = "#2B3328",
        winterYellow = "#49443C",
        winterRed = "#43242B",
        winterBlue = "#252535",
        autumnGreen = "#76946A",
        autumnRed = "#C34043",
        autumnYellow = "#DCA561",

        -- Diag
        samuraiRed = "#C34043",
        roninYellow = "#DCA561",
        zenAqua1 = "#6A9589",
        inkBlue = "#658594",

        -- Fg and Comments
        oldWhite = "#C5C9C7",
        fujiWhite = "#f2f1ef",

        springViolet1 = "#938AA9",
        springBlue = "#7FB4CA",
        zenAqua2 = "#7AA89F",

        springGreen = "#98BB6C",
        carpYellow = "#E6C384",

        zenRed = "#E46876",
        katanaGray = "#717C7C",

        inkBlack0 = "#14171d",
        inkBlack1 = "#1f1f26",
        inkBlack2 = "#22262D",
        inkBlack3 = "#393B44",
        inkBlack4 = "#4b4e57",

        inkWhite = "#C5C9C7",
        inkGreen = "#87a987",
        inkGreen2 = "#8a9a7b",
        inkPink = "#a292a3",
        inkOrange = "#b6927b",
        inkOrange2 = "#b98d7b",
        inkGray = "#A4A7A4",
        inkGray1 = "#909398",
        inkGray2 = "#75797f",
        inkGray3 = "#5C6066",
        inkBlue2 = "#8ba4b0",
        inkViolet = "#8992a7",
        inkRed = "#c4746e",
        inkAqua = "#8ea4a2",
        inkAsh = "#5C6066",
        inkTeal = "#949fb5",
        inkYellow = "#c4b28a", --"#a99c8b",
        -- "#8a9aa3",

        -- Mist Shades
        mist0 = "#22262D",
        mist1 = "#2a2c35",
        mist2 = "#393B44",
        mist3 = "#5C6066",

        mistWhite = "#C5C9C7",
        mistGreen = "#87a987",
        mistGreen2 = "#8a9a7b",
        mistPink = "#a292a3",
        mistOrange = "#b6927b",
        mistOrange2 = "#b98d7b",
        mistGray = "#A4A7A4",
        mistGray1 = "#909398",
        mistGray2 = "#75797f",
        mistGray3 = "#5C6066",
        mistBlue2 = "#8ba4b0",
        mistViolet = "#8992a7",
        mistRed = "#c4746e",
        mistAqua = "#8ea4a2",
        mistAsh = "#5C6066",
        mistTeal = "#949fb5",
        mistYellow = "#c4b28a",

        pearlInk0 = "#22262D",
        pearlInk1 = "#545464",
        pearlInk2 = "#43436c",
        pearlGray = "#e2e1df",
        pearlGray2 = "#5C6068",
        pearlGray3 = "#6D6D69",
        pearlGray4 = "#9F9F99",

        pearlWhite0 = "#f2f1ef",
        pearlWhite1 = "#e2e1df",
        pearlWhite2 = "#dddddb",
        pearlWhite3 = "#cacac7",
        pearlViolet1 = "#a09cac",
        pearlViolet2 = "#766b90",
        pearlViolet3 = "#c9cbd1",
        pearlViolet4 = "#624c83",
        pearlBlue1 = "#c7d7e0",
        pearlBlue2 = "#b5cbd2",
        pearlBlue3 = "#9fb5c9",
        pearlBlue4 = "#4d699b",
        pearlBlue5 = "#5d57a3",
        pearlGreen = "#6f894e",
        pearlGreen2 = "#6e915f",
        pearlGreen3 = "#b7d0ae",
        pearlPink = "#b35b79",
        pearlOrange = "#cc6d00",
        pearlOrange2 = "#e98a00",
        pearlYellow = "#77713f",
        pearlYellow2 = "#836f4a",
        pearlYellow3 = "#de9800",
        pearlYellow4 = "#f9d791",
        pearlRed = "#c84053",
        pearlRed2 = "#d7474b",
        pearlRed3 = "#e82424",
        pearlRed4 = "#d9a594",
        pearlAqua = "#597b75",
        pearlAqua2 = "#5e857a",
        pearlTeal1 = "#4e8ca2",
        pearlTeal2 = "#6693bf",
        pearlTeal3 = "#5a7785",
        pearlCyan = "#d7e3d8",
        gray0 = "#111111",
        gray2 = "#181818",
    }

    -- setup must be called before loading
    vim.cmd("colorscheme kanso")
    c.fg = get_color("Normal", "fg")
    c.bg = nil
    if theme_variant == "dark" then
        hl_overwrite({
            SnacksImageMath = { bg = nil, fg = c.fg },
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
        })
        vim.api.nvim_set_hl(0, "StatusLineMain", { fg = "#000000", italic = false })
        vim.api.nvim_set_hl(0, "StatusLineSecondary", { fg = "#777777" })
    end
end
