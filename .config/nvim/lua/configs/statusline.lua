vim.api.nvim_set_hl(0, "SPrimary", { fg = "#DDDDDD", italic = false })
vim.api.nvim_set_hl(0, "SSecond", { fg = "#888888" })
local function get_git_diff()
    local icons = { added = "󰐖", changed = "󰏬", removed = "" }
    local colors = { added = "%#GitSignsAdd#", changed = "%#GitSignsChange#", removed = "%#GitSignsDelete#" }
    local signs = vim.b.gitsigns_status_dict
    local info = ""
    if signs == nil then
        return "%#StatusLine#"
    end
    local c = 0
    for name, icon in pairs(icons) do
        if tonumber(signs[name]) and signs[name] > 0 then
            info = info .. " " .. colors[name] .. icons[name] .. " %#StatusLine#" .. signs[name]
        end
    end
    return info .. "%#StatusLine#   "
end

local function fname()
    local fname = vim.fn.fnamemodify(vim.fn.expand("%"), ":t")
    local modified = vim.fn.getbufvar("%", "&modified")
    if modified == 1 then
        return "%#SPrimary#" .. fname .. " 󰧞"
    else
        return "%#SPrimary#" .. fname
    end
end

local function root_dir()
    local fpath = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    return "%#SSecond#  " .. fpath
end

local function modes()
    local modes = {
        ["n"] = "NORMAL",
        ["no"] = "NORMAL",
        ["v"] = "VISUAL",
        ["V"] = "VISUAL LINE",
        [""] = "VISUAL BLOCK",
        ["s"] = "SELECT",
        ["S"] = "SELECT LINE",
        [""] = "SELECT BLOCK",
        ["i"] = "INSERT",
        ["ic"] = "INSERT",
        ["R"] = "REPLACE",
        ["Rv"] = "VISUAL REPLACE",
        ["c"] = "COMMAND",
        ["cv"] = "VIM EX",
        ["ce"] = "EX",
        ["r"] = "PROMPT",
        ["rm"] = "MOAR",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        ["t"] = "TERMINAL",
    }
    local modes_color = {
        ["n"] = "%#Function#",
        ["no"] = "%#Function#",
        ["v"] = "%#Keyword#",
        ["V"] = "%#Keyword#",
        [""] = "%#Keyword#",
        ["s"] = "%#SSecond#",
        ["S"] = "%#SSecond#",
        [""] = "%#SSecond#",
        ["i"] = "%#Error#",
        ["ic"] = "%#Error#",
        ["R"] = "%#Error#",
        ["Rv"] = "%#Error#",
        ["c"] = "%#SSecond#",
        ["cv"] = "%#Normal#",
        ["ce"] = "%#Normal#",
        ["r"] = "%#Normal#",
        ["rm"] = "%#Normal#",
        ["r?"] = "%#Normal#",
        ["!"] = "%#Normal#",
        ["t"] = "%#Normal#",
    }
    local current_mode = vim.api.nvim_get_mode().mode
    -- mode = "%#SPrimary#" .. string.format("%s", string.sub(modes[current_mode], 1, 1)):upper()
    mode = "%#SPrimary#" .. string.format("%s", modes[current_mode]):upper()
    return mode
end

local function ftype()
    local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
    local icon, color = require("nvim-web-devicons").get_icon_color(file_name, file_ext, { default = true })
    vim.api.nvim_set_hl(0, "SFtype", { fg = color })
    local ftype = vim.bo.filetype
    return string.format("%%#SSecond#%s  %%#SSecond#%s", icon, ftype):lower()
end

local function progress()
    local cur = vim.fn.line(".")
    local total = vim.fn.line("$")

    return "%#SPrimary#  " .. cur .. " / " .. total
end

local function recording_macro()
    local reg = vim.fn.reg_recording()

    if not (reg == "") then
        return "%#SPrimary#@" .. reg .. " recording  %S"
    else
        return "%S"
    end
end

Statusline = {}

Statusline.active = function()
    return table.concat({
        "  ",
        modes(),
        "   ",
        fname(),
        "   ",
        root_dir(),
        "%=",
        recording_macro(),
        "   ",
        get_git_diff(),
        ftype(),
        "   ",
        progress(),
        " ",
    })
end

Statusline.short = function()
    return table.concat({
        "  ",
        modes(),
        "%=",
        recording_macro(),
        " ",
    })
end

function Statusline.inactive()
    return " %#Comment# %t"
end

vim.api.nvim_exec(
    [[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au WinEnter,BufEnter,FileType oil setlocal statusline=%!v:lua.Statusline.short()
  augroup END
]],
    false
)
