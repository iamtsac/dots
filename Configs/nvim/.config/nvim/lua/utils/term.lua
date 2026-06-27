local M = {}

M.active_workspaces = {} -- Tracks the active workspace ID per project
M.last_focused_pane = {} -- Tracks the last focused pane per project+workspace

M.terminal_history = {}       -- Chronological list of all active terminal IDs
M.last_global_opened_id = nil -- Tracks if a terminal was opened via the global toggle

M.resize_step = 5
M.split_height = 0.3
M.split_width = 0.4

M.project_registry = {}
M.next_project_id = 1

function M.get_project_id()
    local cwd = vim.fn.getcwd()
    if not M.project_registry[cwd] then
        M.project_registry[cwd] = M.next_project_id
        M.next_project_id = M.next_project_id + 1
    end
    return M.project_registry[cwd]
end

function M.parse_id(id)
    if not id then
        return nil, nil, nil
    end
    local pid = math.floor(id / 10000)
    local ws = math.floor((id % 10000) / 10)
    local pane = id % 10
    return pid, ws, pane
end

function M.get_context(t)
    local active_pid = M.get_project_id()
    local ws_id = M.active_workspaces[active_pid] or 1

    if t then
        local id = M.get_term_id(t)
        local t_pid, t_ws, _ = M.parse_id(id)
        if t_pid == active_pid and t_ws then
            ws_id = t_ws
        end
    end
    return active_pid, ws_id
end

function M.get_title(ws_id, pane_id)
    return "%#SnacksPickerDir#   %*%#Comment#Workspace %#SnacksPickerMatch#"
        .. ws_id
        .. "%#Comment# | Pane %#String#"
        .. pane_id
        .. "%#Comment# | %#String#%{b:term_title}%* %="
end

function M.update_and_get_workspace()
    local pid = M.get_project_id()
    local count = vim.v.count

    if count > 0 then
        M.active_workspaces[pid] = count
    elseif not M.active_workspaces[pid] then
        M.active_workspaces[pid] = 1
    end

    return M.active_workspaces[pid]
end

function M.get_term_id(t)
    if not t or not t.buf or not vim.api.nvim_buf_is_valid(t.buf) then
        return nil
    end
    local ok, data = pcall(function()
        return vim.b[t.buf].snacks_terminal
    end)
    if ok and data and data.id then
        return tonumber(data.id)
    end
    if t.opts and t.opts.count then
        return tonumber(t.opts.count)
    end
    return nil
end

function M.get_neovim_win(t)
    if t and t.buf and vim.api.nvim_buf_is_valid(t.buf) then
        local wid = vim.fn.bufwinid(t.buf)
        if wid ~= -1 then
            return wid
        end
    end
    return nil
end

function M.get_next_split_id(ws_id)
    local pid = M.get_project_id()
    local terms = Snacks.terminal.list()
    local used_subs = {}

    for _, t in ipairs(terms) do
        local t_pid, t_ws, t_pane = M.parse_id(M.get_term_id(t))
        if t_pid == pid and t_ws == ws_id then
            used_subs[t_pane] = true
        end
    end

    for i = 1, 9 do
        if not used_subs[i] then
            return (pid * 10000) + (ws_id * 10) + i
        end
    end

    vim.notify("Workspace " .. ws_id .. " reached the maximum of 9 splits.", vim.log.levels.WARN)
    return nil
end

function M.record_terminal_focus(tid)
    if not tid then return end
    for i, id in ipairs(M.terminal_history) do
        if id == tid then
            table.remove(M.terminal_history, i)
            break
        end
    end
    table.insert(M.terminal_history, 1, tid)
end

function M.toggle_workspace_group(opts)
    local terms = Snacks.terminal.list()
    local group_terms = {}
    local any_visible = false
    local ws_id = opts.ws_id
    local pid = M.get_project_id()
    local default_position = opts.default_position
    local default_style = opts.default_style
    local width = opts.width
    local height = opts.height

    local memory_key = pid .. "_" .. ws_id

    for _, t in ipairs(terms) do
        local t_pid, t_ws, _ = M.parse_id(M.get_term_id(t))
        if t_pid == pid and t_ws == ws_id then
            table.insert(group_terms, t)
            if M.get_neovim_win(t) then
                any_visible = true
            end
        end
    end

    if #group_terms == 0 then
        local first_id = (pid * 10000) + (ws_id * 10) + 1
        local target_width = default_position == "right" and (width or M.split_width) or nil
        local target_height = default_position == "bottom" and (height or M.split_height) or nil

        Snacks.terminal.toggle(nil, {
            count = first_id,
            cwd = vim.fn.getcwd(),
            win = {
                style = default_style,
                position = default_position,
                width = default_position == "float" and width or target_width,
                height = default_position == "float" and height or target_height,
                border = "bold",
            },
        })
        M.last_focused_pane[memory_key] = first_id
        M.record_terminal_focus(first_id)
        return
    end

    if any_visible then
        local current_win = vim.api.nvim_get_current_win()
        for _, t in ipairs(group_terms) do
            if M.get_neovim_win(t) == current_win then
                M.last_focused_pane[memory_key] = M.get_term_id(t)
                break
            end
        end
        for _, t in ipairs(group_terms) do
            t:hide()
        end
    else
        table.sort(group_terms, function(a, b)
            return (M.get_term_id(a) or 0) < (M.get_term_id(b) or 0)
        end)
        for _, t in ipairs(group_terms) do
            t:show()
        end

        vim.schedule(function()
            local first_win_id = M.get_neovim_win(group_terms[1])
            if first_win_id then
                local config = vim.api.nvim_win_get_config(first_win_id)
                if config.relative == "" then
                    pcall(vim.cmd, "wincmd =")
                end
            end

            local target_id = M.last_focused_pane[memory_key]
            if target_id then
                for _, t in ipairs(group_terms) do
                    if M.get_term_id(t) == target_id then
                        local wid = M.get_neovim_win(t)
                        if wid then
                            pcall(vim.api.nvim_set_current_win, wid)
                            M.record_terminal_focus(target_id)
                        end
                        break
                    end
                end
            end
        end)
    end
end

function M.focus_pane(current_t, pane_num)
    local pid, ws_id = M.get_context(current_t)
    local target_id = (pid * 10000) + (ws_id * 10) + pane_num

    local terms = Snacks.terminal.list()
    for _, t in ipairs(terms) do
        if M.get_term_id(t) == target_id then
            local wid = M.get_neovim_win(t)
            if wid then
                vim.api.nvim_set_current_win(wid)
                M.record_terminal_focus(target_id)
                return
            end
        end
    end

    vim.notify("Pane " .. pane_num .. " not active in Workspace " .. ws_id, vim.log.levels.INFO)
end

function M.toggle_last_focused_global()
    local current_win = vim.api.nvim_get_current_win()
    local terms = Snacks.terminal.list()
    
    -- 1. Identify if cursor is currently inside a terminal window right now
    local cur_tid = nil
    for _, t in ipairs(terms) do
        if M.get_neovim_win(t) == current_win then
            cur_tid = M.get_term_id(t)
            break
        end
    end
    
    -- 2. If looking at the globally opened terminal, hide it immediately
    if cur_tid and cur_tid == M.last_global_opened_id then
        local pid, ws_id, _ = M.parse_id(cur_tid)
        for _, t in ipairs(terms) do
            local t_pid, t_ws, _ = M.parse_id(M.get_term_id(t))
            if t_pid == pid and t_ws == ws_id then
                t:hide()
            end
        end
        M.last_global_opened_id = nil
        return
    end
    
    -- 3. Calculate current scope context statically based on where the cursor is sitting
    local cur_pid, cur_ws
    if cur_tid then
        cur_pid, cur_ws, _ = M.parse_id(cur_tid)
    else
        cur_pid = M.get_project_id()
        cur_ws = M.active_workspaces[cur_pid] or 1
    end
    
    -- 4. Scan history stack for the most recent out-of-scope terminal
    local target_tid = nil
    for _, tid in ipairs(M.terminal_history) do
        local t_pid, t_ws, _ = M.parse_id(tid)
        if t_pid ~= cur_pid or t_ws ~= cur_ws then
            target_tid = tid
            break
        end
    end
    
    if not target_tid then
        vim.notify("No out-of-scope terminal found in history", vim.log.levels.INFO)
        return
    end
    
    -- 5. Locate and execute visibility change on target environment
    local target_terminal = nil
    for _, t in ipairs(terms) do
        if M.get_term_id(t) == target_tid then
            target_terminal = t
            break
        end
    end
    
    if not target_terminal then
        -- Clean up dead ID from history if it doesn't exist anymore
        for i, id in ipairs(M.terminal_history) do
            if id == target_tid then
                table.remove(M.terminal_history, i)
                break
            end
        end
        return M.toggle_last_focused_global() -- Loop to find the next valid match
    end
    
    local win_id = M.get_neovim_win(target_terminal)
    if win_id then
        pcall(vim.api.nvim_set_current_win, win_id)
        M.last_global_opened_id = target_tid
    else
        target_terminal:show()
        vim.schedule(function()
            local new_win_id = M.get_neovim_win(target_terminal)
            if new_win_id then
                pcall(vim.api.nvim_set_current_win, new_win_id)
                M.last_global_opened_id = target_tid
            end
        end)
    end
end

function M.terminal_picker()
    local terms = Snacks.terminal.list()
    local ws_data = {}
    local current_pid = M.get_project_id()

    for _, t in ipairs(terms) do
        local t_pid, ws_id, pane_id = M.parse_id(M.get_term_id(t))

        if t_pid == current_pid then
            local title = "term"
            local is_visible = false

            if t.buf and vim.api.nvim_buf_is_valid(t.buf) then
                title = vim.b[t.buf].term_title or "fish"
                if vim.fn.bufwinid(t.buf) ~= -1 then
                    is_visible = true
                end
            end

            if not ws_data[ws_id] then
                ws_data[ws_id] = { panes = {}, visible = false }
            end
            if is_visible then
                ws_data[ws_id].visible = true
            end

            table.insert(ws_data[ws_id].panes, { id = pane_id, title = title })
        end
    end

    local items = {}
    for ws_id, data in pairs(ws_data) do
        table.sort(data.panes, function(a, b)
            return a.id < b.id
        end)
        local title_list = {}
        for _, pane in ipairs(data.panes) do
            table.insert(title_list, pane.title)
        end

        local titles_str = table.concat(title_list, ", ")
        local status = data.visible and "● Active" or "○ Hidden"
        local pane_word = #data.panes == 1 and "pane" or "panes"

        local text =
            string.format("Workspace %d  %-10s (%d %s)  ➜  %s", ws_id, status, #data.panes, pane_word, titles_str)
        table.insert(items, { text = text, ws_id = ws_id })
    end

    if #items == 0 then
        vim.notify("No active terminal workspaces in this project", vim.log.levels.INFO)
        return
    end

    table.sort(items, function(a, b)
        return a.ws_id < b.ws_id
    end)

    Snacks.picker({
        items = items,
        format = "text",
        layout = { preset = "select", preview = false },
        title = " Terminal Workspaces ",
        actions = {
            confirm = function(picker, item)
                picker:close()
                if item then
                    local pid = M.get_project_id()
                    M.active_workspaces[pid] = item.ws_id
                    M.toggle_workspace_group({
                        ws_id = item.ws_id,
                        default_style = "float",
                        default_position = nil,
                    })
                end
            end,
        },
    })
end

-- AUTOMATION HOOKS
vim.api.nvim_create_autocmd("WinEnter", {
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "snacks_terminal" then
            local ok, data = pcall(function() return vim.b.snacks_terminal end)
            if ok and data and data.id then
                M.record_terminal_focus(tonumber(data.id))
            end
        end
    end,
})

vim.api.nvim_create_autocmd("TermClose", {
    pattern = "*",
    callback = function(args)
        if vim.bo[args.buf].filetype == "snacks_terminal" then
            local ok, data = pcall(function() return vim.b[args.buf].snacks_terminal end)
            if ok and data then
                local tid = tonumber(data.id)
                -- Cleanup tracking values upon terminal exit
                if tid == M.last_global_opened_id then M.last_global_opened_id = nil end
                for i, id in ipairs(M.terminal_history) do
                    if id == tid then
                        table.remove(M.terminal_history, i)
                        break
                    end
                end
            end

            if vim.v.event.status == 0 then vim.cmd("silent! bdelete! " .. args.buf) end
            vim.schedule(function()
                pcall(vim.cmd, "doautocmd WinEnter")
                pcall(vim.cmd, "redrawstatus!")
            end)
        end
    end,
})

return M
