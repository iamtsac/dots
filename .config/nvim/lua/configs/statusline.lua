local branch_cache = ""

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
            local space = (info ~= "") and " " or ""
            info = info .. space .. colors[name] .. icons[name] .. " %#StatusLine#" .. signs[name]
        end
    end
    return "%#StatusLineSecondary#" .. info .. "%#StatusLine#" .. "%#StatusLineSecondary#"
end

local function update_branch()
    vim.system({ "git", "branch", "--show-current" }, { text = true }, function(obj)
        if obj.code == 0 then
            branch_cache = obj.stdout:gsub("%s+", "")
        else
            branch_cache = ""
        end
        vim.schedule(function()
            vim.cmd("redrawstatus")
        end)
    end)
end

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "DirChanged" }, {
    callback = update_branch,
})

local function get_git_branch()
    return branch_cache
end

local function fname()
    local fname = vim.fn.fnamemodify(vim.fn.expand("%"), ":t")
    local modified = vim.fn.getbufvar("%", "&modified")
    -- if modified == 1 then
    --     return "%#StatusLineMain#" .. fname .. " 󰧞"
    -- else
    if fname == "" then
        return "%#StatusLineMain#[No Name]"
    end
    return "%#StatusLineMain#" .. fname
    -- end
end

local function root_dir()
    local fpath = vim.fn.pathshorten(vim.fn.fnamemodify(vim.fn.getcwd(), ":t"))
    local branch = get_git_branch()
    local branch_display = (branch ~= "") and ":" .. "%#StatusLineMain#" .. branch or ""
    return "%#StatusLineSecondary# " .. fpath .. branch_display
end

local function branch()
    local branch_name = vim.fn.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" })
    return "%#StatusLineSecondary# " .. branch_name
end

local function selected_compiler()
    local compiler = vim.b.compiler or vim.g.compiler
    if not compiler then
        return ""
    end

    -- Uses a separator and StatusLineSecondary for a muted, integrated appearance
    return string.format("%%#StatusLineSecondary# 󰣖 %s", compiler)
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
        ["nt"] = "TERMINAL",
    }
    local modes_color = {
        ["n"] = "%#Exception#",
        ["no"] = "%#Exception#",
        ["v"] = "%#Boolean#",
        ["V"] = "%#Boolean#",
        [""] = "%#Boolean#",
        ["s"] = "%#Constant#",
        ["S"] = "%#Constant#",
        [""] = "%#Constant#",
        ["i"] = "%#Function#",
        ["ic"] = "%#Function#",
        ["R"] = "%#String#",
        ["Rv"] = "%#String#",
        ["c"] = "%#Keyword#",
        ["cv"] = "%#Keyword#",
        ["ce"] = "%#Keyword#",
        ["r"] = "%#Title#",
        ["rm"] = "%#Title#",
        ["r?"] = "%#Title#",
        ["!"] = "%#Title#",
        ["t"] = "%#Special#",
        ["nt"] = "%#Special#",
    }
    local current_mode = vim.api.nvim_get_mode().mode
    -- mode = modes_color[current_mode] .. "<" .. string.format("%s", string.sub(modes[current_mode], 1, 1)):upper() .. ">"
    -- mode = "%#StatusLineMain#" .. string.format("%s", modes[current_mode]):upper()
    mode = modes_color[current_mode] .. "<" .. modes[current_mode]:gsub("(%a)%a*%s*", "%1") .. ">"
    return mode
end

local function ftype()
    local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
    local icon, color = require("nvim-web-devicons").get_icon_color(file_name, file_ext, { default = true })
    vim.api.nvim_set_hl(0, "SFtype", { fg = color })
    local ftype = vim.bo.filetype
    if ftype == "" then
        ftype = "text"
    end
    return string.format("%%#SFtype#%s %%#StatusLineSecondary#%s", icon, ftype):lower()
end

local function progress()
local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local first_visible = vim.fn.line("w0")
    local last_visible = vim.fn.line("w$")

    local pos_text = ""

    if first_visible == 1 and last_visible == total_lines then
        pos_text = "All"
    elseif first_visible == 1 then
        pos_text = "Top"
    elseif last_visible == total_lines then
        pos_text = "Bot"
    else
        pos_text = math.floor((first_visible / total_lines) * 100) .. "%%"
    end

    local wrapping = vim.opt_local.wrap:get()
    local text = "%#StatusLineMain# " .. pos_text .. "   L" .. current_line

    if wrapping then
        text = text .. " %#StatusLineSecondary#[*W]"
    end

    return text
end

local function buffer_state()
    -- local mod = vim.bo.modified and "**" or "--"
    local mod = vim.bo.modified and "%#Boolean#" or "%#Statusline#󰧞"
    local read = vim.bo.readonly and "%#Exception#" or mod
    return read
end

local function recording_macro()
    local reg = vim.fn.reg_recording()

    if not (reg == "") then
        return "%#Macro#REC @" .. reg
    else
        -- return "  %S"
        return ""
    end
end

local function lsp_status()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then return "" end

    local names = {}
    for _, client in ipairs(clients) do
        table.insert(names, client.name)
    end
    return "%#StatusLineSecondary#  <" .. table.concat(names, ",") .. ">"
end

local function search_count()
    if vim.v.hlsearch == 0 then return "" end
    local ok, res = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 10 })
    if not ok or next(res) == nil or res.total == 0 then return "" end
    return string.format(" %%#StatusLineMain#[%d/%d]", res.current, res.total)
end

local function diagnostics()
    local counts = {0, 0, 0, 0}
    for _, d in ipairs(vim.diagnostic.get(0)) do
        counts[d.severity] = counts[d.severity] + 1
    end

    local e = counts[vim.diagnostic.severity.ERROR] > 0 and "%#DiagnosticError# " .. counts[vim.diagnostic.severity.ERROR] .. " " or ""
    local w = counts[vim.diagnostic.severity.WARN] > 0 and "%#DiagnosticWarn# " .. counts[vim.diagnostic.severity.WARN] .. " " or ""
    local i = counts[vim.diagnostic.severity.INFO] > 0 and "%#DiagnosticInfo# " .. counts[vim.diagnostic.severity.INFO] .. " " or ""
    local h = counts[vim.diagnostic.severity.HINT] > 0 and "%#DiagnosticHint#󰌵 " .. counts[vim.diagnostic.severity.HINT] .. " " or ""

    local res = e .. w .. i .. h
    if vim.diagnostic.is_enabled({ bufnr = 0 }) then
        return res ~= "" and "  " .. res .. "%#StatusLineSecondary#" or ""
    end
    return ""
end

Statusline = {}

Statusline.active = function()
    return table.concat({
        " ",
        buffer_state(),
        "  ",
        fname(),
        "     ",
        recording_macro(),
        " ",
        progress(),
        "  ",
        modes(),
        search_count(),
        "  ",
        root_dir(),
        "  ",
        get_git_diff(),
        diagnostics(),
        "%#StatusLineSecondary# (",
        ftype(),
        lsp_status(),
        selected_compiler(),
        ")"
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
