require("utils.floating_tabbar").setup({
    position = {row = 0, col = 0.5},
    margin = { top = 0, side = 0 },
    style = {
        bar_prefix = "",
        bar_postfix = "",
        tab_prefix = " ",
        tab_postfix = " ",
        selected_indicator = "● ",
        unselected_indicator = "○ ",
        separator = "",
        active_hl = "FloatingTabsActive",
        inactive_hl = "FloatingTabsInactive",
        border_hl = "FloatingTabsBorder",
        indicator_hl = "FloatingTabsIndicator",
        separator_hl = "FloatingTabsSeparator",
    },
    auto_hide = {
        cursor_overlap = false,
        text_overlap = false,
    },
})

-- function MyTabLine()
--     local s = ""
--     for i = 1, vim.fn.tabpagenr("$") do
--         local tabnr = i
--         local is_selected = tabnr == vim.fn.tabpagenr()

--         local display_name = ""
--         local custom_name = vim.fn.gettabvar(tabnr, "tabname")
--         local buflist = vim.fn.tabpagebuflist(tabnr)
--         local winnr = vim.fn.tabpagewinnr(tabnr)
--         local bufnr = buflist[winnr]
--         local bufname = vim.fn.bufname(bufnr)

--         if custom_name ~= "" then
--             display_name = custom_name
--         elseif tabnr == 1 then
--             local project_dir = vim.fn.fnamemodify(vim.fn.getcwd(-1, tabnr), ":t")
--             display_name = project_dir ~= "" and project_dir or "[Project]"
--         elseif bufname == "" then
--             display_name = "[No Name]"
--         else
--             local parent = vim.fn.fnamemodify(bufname, ":p:h:t")
--             display_name = parent
--         end

--         if is_selected then
--             s = s .. "%#TabLineIndicator#▍%#TabLineSel#" .. tabnr .. ": " .. display_name .. " %#TabLine# "
--         else
--             s = s .. "%#TabLine# " .. tabnr .. ": " .. display_name .. "  "
--         end
--     end

--     return "%#TabLine#" .. s .. "%#TabLineFill#%="
-- end

-- vim.o.tabline = "%!v:lua.MyTabLine()"

-- local tab_group = vim.api.nvim_create_augroup("GlobalTabHistory", { clear = true })
-- local tab_history = {}

-- vim.api.nvim_create_autocmd("TabEnter", {
--     group = tab_group,
--     callback = function()
--         local current_tab = vim.api.nvim_get_current_tabpage()

--         -- Remove the tab from history if it's already there (to avoid duplicates)
--         for i, tab in ipairs(tab_history) do
--             if tab == current_tab then
--                 table.remove(tab_history, i)
--                 break
--             end
--         end

--         table.insert(tab_history, 1, current_tab)
--     end,
-- })

-- vim.api.nvim_create_autocmd("TabClosed", {
--     group = tab_group,
--     callback = function()
--         local valid_history = {}
--         for _, tab in ipairs(tab_history) do
--             if vim.api.nvim_tabpage_is_valid(tab) then
--                 table.insert(valid_history, tab)
--             end
--         end
--         tab_history = valid_history

--         if #tab_history > 0 then
--             local target_tab = tab_history[1]
--             vim.schedule(function()
--                 if vim.api.nvim_tabpage_is_valid(target_tab) then
--                     vim.api.nvim_set_current_tabpage(target_tab)
--                 end
--             end)
--         end
--     end,
-- })

