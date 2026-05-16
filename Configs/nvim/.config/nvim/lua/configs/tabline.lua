function MyTabLine()
    local s = ""
    for i = 1, vim.fn.tabpagenr("$") do
        local tabnr = i
        local is_selected = tabnr == vim.fn.tabpagenr()

        local display_name = ""
        local custom_name = vim.fn.gettabvar(tabnr, "tabname")
        local buflist = vim.fn.tabpagebuflist(tabnr)
        local winnr = vim.fn.tabpagewinnr(tabnr)
        local bufnr = buflist[winnr]
        local bufname = vim.fn.bufname(bufnr)

        if custom_name ~= "" then
            display_name = custom_name
        elseif tabnr == 1 then
            local project_dir = vim.fn.fnamemodify(vim.fn.getcwd(-1, tabnr), ":t")
            display_name = project_dir ~= "" and project_dir or "[Project]"
        elseif bufname == "" then
            display_name = "[No Name]"
        else
            local parent = vim.fn.fnamemodify(bufname, ":p:h:t")
            display_name = parent
        end

        if is_selected then
            s = s .. "%#TabLineIndicator#▍%#TabLineSel#" .. tabnr .. ": " .. display_name .. " %#TabLine# "
        else
            s = s .. "%#TabLine# " .. tabnr .. ": " .. display_name .. "  "
        end
    end

    return "%#TabLine#" .. s .. "%#TabLineFill#%="
end

vim.o.tabline = "%!v:lua.MyTabLine()"
