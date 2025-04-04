function MyTabLine()
    local s = ""
    for i = 1, vim.fn.tabpagenr("$") do
        local winnr = vim.fn.tabpagewinnr(i)
        local buflist = vim.fn.tabpagebuflist(i)
        local bufnr = buflist[winnr]
        local bufname = vim.fn.bufname(bufnr)
        local bufmodified = vim.fn.getbufvar(bufnr, "&modified")

        if bufname == "" then
            bufname = "[No Name]"
        end

        -- Highlight active tab
        if i == vim.fn.tabpagenr() then
            s = s .. "%#TabLineSel#"
        else
            s = s .. "%#TabLine#"
        end

        -- Tab number
        s = s .. " " .. i
        -- s = s .. " " .. vim.fn.fnamemodify(bufname, ":p:t")

        -- Show `+` if buffer is modified
        if bufmodified == 1 then
            s = s .. " [+]"
        end

        s = s .. " %T"
    end

    -- Right-aligned close button
    s = s .. "%#TabLineFill#%="
    -- s = s .. "%#TabLineFill#%T%=%#TabLineFill#X"

    return s
end

vim.o.tabline = "%!v:lua.MyTabLine()"
