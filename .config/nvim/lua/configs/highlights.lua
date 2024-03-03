local fn = vim.fn

local function get_color(group, attr)
    return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
end

vim.api.nvim_set_hl(0, "LineNr", { bg = nil, ctermbg = nil, default = true })

-- local bg = get_color("@constructor", "fg#")
-- local fg = get_color("TroubleCount", "bg#")
-- 
-- vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = fg, bg = bg  })
-- vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = fg, bg = bg })
-- vim.api.nvim_set_hl(0, "TelescopePreview", { fg  = fg, bg = bg })
-- vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = fg, bg = bg })
