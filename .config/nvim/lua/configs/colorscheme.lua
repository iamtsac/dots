local hl_overwrite = function(hls)
    for k, v in pairs(hls) do
        vim.api.nvim_set_hl(0, k, v)
    end
end

local function get_color(group, attr)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

vim.opt.background = "dark"
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
    NormalFloat = { bg = nil },
    NormalNC = { bg = nil },
    SignColumn = { bg = nil },
    LineNr = { fg = "#888888" },

    TabLine = { bg = c.gray2, fg = c.fg },
    TabLineFill = { bg = nil, fg = nil },
    TabLineSel = { bg = c.blue, fg = c.bg },
    ["@module.python"] = { link = "Type" },
    ["@constructor"] = { link = "@variable" },

    -- ["@property"] = { link="Type" },
    -- StatusLine = { fg = nil, bg = nil },
    -- StatusLineNC = { fg = nil, bg = c.gray1 },

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

--[[ local c = require("no-clown-fiesta.palette")
require("no-clown-fiesta").setup({
  transparent = false, -- Enable this to disable the bg color
  styles = {
    -- You can set any of the style values specified for `:h nvim_set_hl`
    comments = {},
    functions = {},
    keywords = {},
    lsp = {},
    match_paren = {},
    type = { fg = c.red },
    variables = {},

  },
}) ]]

--[[ local c = require('nvim-tundra.palette.jungle')
c.gray._900 = "#101010"
require('nvim-tundra').setup({
  transparent_background = false,
  dim_inactive_windows = {
    enabled = false,
    color = nil,
  },
  sidebars = {
    enabled = true,
    color = nil,
  },
  editor = {
    search = {},
    substitute = {},
  },
  syntax = {
    booleans = { bold = true, italic = false },
    comments = { fg = c.gray._400, bold = true, italic = true },
    conditionals = {},
    constants = { bold = true },
    fields = { fg = c.white },
    functions = {},
    keywords = {},
    loops = {},
    numbers = { bold = true },
    operators = {fg = c.green._500, bold = true },
    punctuation = {},
    strings = { fg = c.sand._500 },
    types = { fg = c.green._500, italic = false },
  },
  diagnostics = {
    errors = {},
    warnings = {},
    information = {},
    hints = {},
  },
  plugins = {
    lsp = true,
    semantic_tokens = true,
    treesitter = true,
    telescope = true,
    nvimtree = true,
    cmp = true,
    context = true,
    dbui = true,
    gitsigns = true,
    neogit = true,
    textfsm = true,
  },
  overwrite = {
    colors = {
        gray = {
            _900 = "#101010",
            _200 = "#FFFFFF"
        }
    },
    highlights = {
    },
  },
})

vim.g.tundra_biome = 'jungle'

vim.cmd.colorscheme("tundra")

hl_overwrite = {
    LineNr = { fg = c.gray._400, bg = c.gray._950 },
    SnacksPickerBorder = { fg = c.gray._900, bg = c.gray._900 },
    SnacksPickerInput = { fg = c.gray._50, bg = c.gray._950 },
    SnacksPickerInputBorder = { fg = c.gray._950, bg = c.gray._950 },
    SnacksPickerBoxBorder = { fg = c.gray._950, bg = c.gray._950 },
    SnacksPickerTitle = { fg = c.gray._900, bg = c.green._600 },
    SnacksPickerBoxTitle = { fg = c.gray._950, bg = c.green._600 },
    SnacksPickerList = { bg = c.gray._950, fg = c.white },
    SnacksPickerDir = { fg = c.gray._500 },
    SnacksPickerPrompt = { fg = c.red._950, bg = c.gray._950 },
    SnacksPickerPreviewTitle = { fg = c.gray._900, bg = c.red._950 },
    SnacksPickerPreview = { bg = c.gray._900 },
    SnacksPickerToggle = { bg = c.green._600, fg = c.gray._900 },
    ["@type.cpp"] = { fg = "#FFFFFF" },
}
for k, v in pairs(hl_overwrite) do
    vim.api.nvim_set_hl(0, k, v)
end ]]
