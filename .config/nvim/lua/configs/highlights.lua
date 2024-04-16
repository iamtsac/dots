local fn = vim.fn

local function get_color(group, attr)
    return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
end

-- vim.api.nvim_set_hl(0, "LineNr", { guibg = nil, ctermbg = nil})
-- vim.api.nvim_set_hl(0, "WhichKey", { bg = nil, ctermbg = nil, default = true })

vim.cmd([[hi! LineNr guibg=none ctermbg=none]])
vim.cmd([[hi! NormalFloat guibg=none ctermbg=none]])
vim.cmd([[hi! WhichKeyFloat guibg=none ctermbg=none]])
vim.cmd([[hi! FloatBorder guibg=none ctermbg=none blend=100]])
vim.cmd([[hi! SignColumn guibg=none ctermbg=none]])
-- vim.cmd([[hi! Pmenu guibg=none ctermbg=none]])
