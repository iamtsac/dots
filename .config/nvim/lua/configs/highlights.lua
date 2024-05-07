local fn = vim.fn

local function get_color(group, attr)
    return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
end

-- vim.cmd([[hi! Normal guibg=none ctermbg=none]])
vim.cmd([[hi! EndOfBuffer guibg=none ctermbg=none]])
-- vim.cmd([[hi! LineNr guibg=none ctermbg=none]])
-- vim.cmd([[hi! CursorLineNr guifg=#ffffff]])
vim.cmd([[hi! NormalFloat guibg=none ctermbg=none]])
vim.cmd([[hi! WhichKeyFloat guibg=none ctermbg=none]])
vim.cmd([[hi! FloatBorder guibg=none ctermbg=none blend=100]])
vim.cmd([[hi! SignColumn guibg=none ctermbg=none]])
