local M = {}

M.hl_overwrite = function(hls)
    for k, v in pairs(hls) do
        vim.api.nvim_set_hl(0, k, v)
    end
end

M.get_color = function(group, attr)
    return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

M.hl_markdown_code = function(c1, c2)
    M.hl_overwrite({ RenderMarkdownCode = { bg = c1 } })
    vim.api.nvim_create_augroup("MarkdownEvent", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
        group = "MarkdownEvent",
        pattern = {"markdown"},
        callback = function()
            M.hl_overwrite({ RenderMarkdownCode = { bg = c2 } })
        end,
    })

    vim.api.nvim_create_autocmd("BufLeave", {
        group = "MarkdownEvent",
        pattern = {"markdown"},
        callback = function()
            M.hl_overwrite({ RenderMarkdownCode = { bg = c1 } })
        end,
    })
end

M.read_args = function(path)
    local file = io.open(path, "r")
    if not file then return {} end
    local args = {}
    for l in file:lines() do
        local content = {}
        for m in l:gmatch("([^=]+)=?") do
            table.insert(content, m)
        end
        if content[1] then
            args[content[1]] = content[2]
        end
    end
    file:close()
    return args
end

return M
