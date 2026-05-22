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

function M.tab_picker()
    local function get_items()
        local tabpages = vim.api.nvim_list_tabpages()
        local items = {}

        for idx, tabpage in ipairs(tabpages) do
            local success, tabname = pcall(function()
                return vim.api.nvim_tabpage_get_var(tabpage, "tabname")
            end)

            local win = vim.api.nvim_tabpage_get_win(tabpage)
            local buf = vim.api.nvim_win_get_buf(win)
            local buf_name = vim.api.nvim_buf_get_name(buf)

            local title = ""
            local is_custom = false

            if success and tabname and tabname ~= "" then
                title = tabname
                is_custom = true
            else
                title = buf_name ~= "" and vim.fn.fnamemodify(buf_name, ":t") or "[No Name]"
            end

            local path = buf_name ~= "" and vim.fn.fnamemodify(buf_name, ":~:.") or ""

            table.insert(items, {
                text = string.format("%d: %s", idx, title),
                idx = idx,
                tabpage = tabpage,
                file = buf_name,
                comment = path,
                is_custom = is_custom,
            })
        end
        return items
    end

    -- Launch compact Ivy Picker
    require("snacks").picker.pick({
        source = "tabs",
        title = " Tabs List ",
        layout = {
            preset = "ivy",
            preview = false, -- Turn off preview pane safely
            layout = {
                height = 0.3, -- Explicitly locks the split layout window to 8 rows tall
            },
        },
        items = get_items(),
        format = function(item, _)
            local title_hl = item.is_custom and "SnacksPickerSpecial" or "SnacksPickerText"
            return {
                { string.format("%d: ", item.idx), "SnacksPickerIdx" },
                { "󰓩 ", "SnacksPickerIcon" },
                { " " },
                { item.text:match(":%s*(.*)"), title_hl },
                { " " },
                { item.comment or "", "SnacksPickerComment" },
            }
        end,
        actions = {
            confirm = function(picker, item)
                picker:close()
                if item and vim.api.nvim_tabpage_is_valid(item.tabpage) then
                    vim.api.nvim_set_current_tabpage(item.tabpage)
                end
            end,
            delete_tab = function(picker, item)
                if not item then
                    return
                end

                if #vim.api.nvim_list_tabpages() <= 1 then
                    vim.notify("Cannot close the final remaining tab.", vim.log.levels.WARN)
                    return
                end

                if vim.api.nvim_tabpage_is_valid(item.tabpage) then
                    vim.api.nvim_cmd({ cmd = "tabclose", args = { tostring(item.idx) } }, {})

                    picker.opts.items = get_items()
                    picker:find()
                end
            end,
        },
        win = {
            input = {
                keys = {
                    -- map <C-d> in both normal/insert mode to delete
                    ["<C-d>"] = { "delete_tab", mode = { "n", "i" } },
                    -- optional: map 'd' in normal mode to match common native list interactions
                    ["d"] = { "delete_tab", mode = { "n" } },
                },
            },
        },
    })
end

return M
