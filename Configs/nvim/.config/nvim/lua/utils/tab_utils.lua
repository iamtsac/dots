local M = {}

M.safe_tab_close = function()
    local unsaved = {}
    local visible_bufs = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        visible_bufs[vim.api.nvim_win_get_buf(win)] = true
    end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local is_listed = vim.bo[buf].buflisted
        local is_loaded = vim.api.nvim_buf_is_loaded(buf)
        local is_modified = vim.bo[buf].modified

        if is_loaded and is_modified and (is_listed or visible_bufs[buf]) then
            local name = vim.fn.bufname(buf)
            name = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":t")
            table.insert(unsaved, name)
        end
    end

    if #unsaved > 0 then
        vim.notify(
            "Cannot close tab. Unsaved buffers in this scope:\n- " .. table.concat(unsaved, "\n- "),
            vim.log.levels.ERROR
        )
        return
    end
    vim.cmd("tabclose")
end

return M
