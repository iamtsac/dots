local os = require 'os'
local colors = dofile(os.getenv('HOME') .. '/.config/nvim/lua/configs/colors.lua')
local helpers = require 'incline.helpers'
local devicons = require 'nvim-web-devicons'

local get_color = function(group, attr)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

local function get_git_diff(props)
      -- local icons = { removed = '', changed = '', added = '' }
      local icons = { added = " ", modified = "󰝤 ", removed = " " }
      local config = require('incline.config')
      local signs = vim.b[props.buf].gitsigns_status_dict
      local labels = {}
      if signs == nil then
        return labels
      end
      for name, icon in pairs(icons) do
        if tonumber(signs[name]) and signs[name] > 0 then
          table.insert(labels, { icon .. signs[name] .. ' ', guibg = colors.bg, blend = 100 , guifg = get_color("Diff"..name, "fg")})
        end
      end
      if #labels > 0 then
        table.insert(labels, 1, {' ', guibg=colors.bg})
        table.insert(labels, {' '})
        config.window.padding.left = 0
      else 
        config.window.padding.left = 0
      end
      return labels
end

require('incline').setup {
  debounce_threshold = {
    falling = 50,
    rising = 10
  },
  hide = {
    cursorline = true,
    focused_win = false,
    only_win = false
  },
  highlight = {
    groups = {
      InclineNormal = {
        default = true,
        guifg = colors.bg,
        guibg = colors.violet,
        gui = "bold",
      },
      InclineNormalNC = {
        default = true,
        guifg = colors.fg,
        guibg = colors.bg,
      }
    }
  },
  ignore = {
    buftypes = "special",
    filetypes = {},
    floating_wins = true,
    unlisted_buffers = true,
    wintypes = "special"
  },
  -- render = "basic",
  render = function(props)
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
      if filename == '' then
          filename = '[No Name]'
      end
      local modified = vim.bo[props.buf].modified
      if props.focused == true then
          return {
            {" ", guibg = colors.bg, guifg = colors.violet } ,
            {" "} ,
            {get_git_diff(props)},
            filename,
            modified and { ' 󰻃', gui = 'bold' } or '',
            {" "} ,
            {"", guibg = colors.bg, guifg = colors.violet } ,
          }
      else 
          return {
            {" ", guibg = colors.bg, guifg = colors.bg } ,
            {" "} ,
            {get_git_diff(props)},
            filename,
            modified and { ' 󰻃', gui = 'bold' } or '',
            {" "} ,
            {"", guibg = colors.bg, guifg = colors.bg } ,
          }
      end
      end,
  window = {
    margin = {
      horizontal = 1,
      vertical = 1
    },
    options = {
      signcolumn = "no",
      wrap = false
    },
    overlap = {
      borders = true,
      statusline = false,
      tabline = false,
      winbar = false
    },
    padding = {left = 0, right = 0},
    padding_char = " ",
    placement = {
      horizontal = "right",
      vertical = "top"
    },
    width = "fit",
    winhighlight = {
      active = {
        EndOfBuffer = "None",
        Normal = "InclineNormal",
        Search = "None"
      },
      inactive = {
        EndOfBuffer = "None",
        Normal = "InclineNormalNC",
        Search = "None"
      }
    },
    zindex = 50
  }
}
