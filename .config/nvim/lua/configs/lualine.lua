local os = require("os")
local colors = dofile(os.getenv("HOME") .. "/.config/nvim/lua/configs/colors.lua")
local helpers = require("incline.helpers")
local devicons = require("nvim-web-devicons")

local get_color = function(group, attr)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

local bubbles_theme = {
  normal = {
    a = { fg = colors.bg, bg = colors.violet },
    b = { fg = colors.fg, bg = colors.grey },
    c = { fg = colors.fg },
  },

  insert = { a = { fg = colors.bg, bg = colors.blue } },
  visual = { a = { fg = colors.bg, bg = colors.cyan } },
  replace = { a = { fg = colors.bg, bg = colors.red } },

  inactive = {
    a = { fg = colors.fg, bg = colors.bg },
    b = { fg = colors.fg, bg = colors.bg },
    c = { fg = colors.fg },
  },
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = bubbles_theme,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = true,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
-- require('slimline').setup({
--   bold = false, -- makes primary parts and mode bold
--   verbose_mode = false, -- Mode as single letter or as a word
--   style = 'fg', -- or "fg". Whether highlights should be applied to bg or fg of components
--   mode_follow_style = true, -- Whether the mode color components should follow the style option
--   workspace_diagnostics = false, -- Whether diagnostics should show workspace diagnostics instead of current buffer
--   components = { -- Choose components and their location
--     left = {
--       "mode",
--       "path",
--       "git",
--     },
--     center = {
--     },
--     right = {
--       "diagnostics",
--       "filetype_lsp",
--       "progress"
--     }
--   },
--   -- spaces = {
--   --   components = ' ', -- string between components
--   --   left = ' ', -- string at the start of the line
--   --   right = ' ', -- string at the end of the line
--   -- },
--   -- sep = {
--   --   hide = {
--   --     first = false, -- hides the first separator
--   --     last = false, -- hides the last separator
--   --   },
--   --   left = '', -- left separator of components
--   --   right = '', -- right separator of components
--   -- },
--   hl = {
--     modes = {
--       normal = 'Type', -- highlight base of modes
--       insert = 'Function',
--       pending = 'Boolean',
--       visual = 'Keyword',
--       command = 'String',
--     },
--     base = 'Comment', -- highlight of everything in in between components
--     primary = 'Normal', -- highlight of primary parts (e.g. filename)
--     secondary = 'Comment', -- highlight of secondary parts (e.g. filepath)
--   },
--   icons = {
--     diagnostics = {
--       ERROR = ' ',
--       WARN = ' ',
--       HINT = ' ',
--       INFO = ' ',
--     },
--     git = {
--       branch = '',
--     },
--     folder = ' ',
--     lines = ' ',
--     recording = ' ',
--     buffer = {
--       modified = '',
--       read_only = '',
--     },
--   },
-- })
