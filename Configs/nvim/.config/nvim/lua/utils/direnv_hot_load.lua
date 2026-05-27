vim.api.nvim_create_user_command('RefreshDirenv', function()
    local handle = io.popen("direnv export json")
    local result = handle:read("*a")
    handle:close()

    local json = vim.fn.json_decode(result)
    if json then
        for k, v in pairs(json) do
            vim.env[k] = v
        end
    end
end, {})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = ".envrc",
    callback = function()
        vim.cmd("RefreshDirenv")
        vim.notify("Direnv updated automatically", vim.log.levels.INFO)
    end,
})
