_G.FloatingTabs = {}

local tab_group = vim.api.nvim_create_augroup("GlobalFloatingTabs", { clear = true })
local tab_history = {}
local float_win = nil
local float_buf = nil
local ns_id = vim.api.nvim_create_namespace("FloatingTabs")

local config = {
    -- Can be a string: "top-right", "top-left", "top-center", "bottom-right", "bottom-left", "bottom-center"
    -- OR a percentage table: { row = 0.0, col = 1.0 } (0.0 is top/left, 1.0 is bottom/right)
    position = "top-right",
    margin = {
        top = 0, -- Absolute row offset
        side = 1, -- Absolute column offset
    },
    -- Set to true to add a fake empty line at the top so text never goes under it
    reserve_top_space = true,
    style = {
        bar_prefix = "",
        bar_postfix = "",
        tab_prefix = " ",
        tab_postfix = " ",
        selected_indicator = "▍",
        unselected_indicator = "",
        separator = "",
        active_hl = "FloatingTabsActive",
        inactive_hl = "FloatingTabsInactive",
        border_hl = "FloatingTabsBorder",
        indicator_hl = "FloatingTabsIndicator",
        separator_hl = "FloatingTabsSeparator",
    },
    auto_hide = {
        cursor_overlap = true,
        text_overlap = true,
    },
}

-- When closing a tab focus the the most recent visited tab.
vim.api.nvim_create_autocmd("TabEnter", {
    group = tab_group,
    callback = function()
        local current_tab = vim.api.nvim_get_current_tabpage()
        for i, tab in ipairs(tab_history) do
            if tab == current_tab then
                table.remove(tab_history, i)
                break
            end
        end
        table.insert(tab_history, 1, current_tab)
    end,
})

vim.api.nvim_create_autocmd("TabClosed", {
    group = tab_group,
    callback = function()
        local valid_history = {}
        for _, tab in ipairs(tab_history) do
            if vim.api.nvim_tabpage_is_valid(tab) then
                table.insert(valid_history, tab)
            end
        end
        tab_history = valid_history

        if #tab_history > 0 then
            local target_tab = tab_history[1]
            vim.schedule(function()
                if vim.api.nvim_tabpage_is_valid(target_tab) then
                    vim.api.nvim_set_current_tabpage(target_tab)
                end
            end)
        end
    end,
})

local function draw_floating_tabs()
    local total_tabs = vim.fn.tabpagenr("$")
    if total_tabs <= 1 then
        if float_win and vim.api.nvim_win_is_valid(float_win) then
            pcall(vim.api.nvim_win_close, float_win, true)
            float_win = nil
        end
        return
    end

    local full_text = ""
    local highlights = {}
    local current_byte = 0
    local total_display_width = 0

    local function add_text(text, hl)
        if not text or text == "" then
            return
        end
        local b_len = string.len(text)
        local d_len = vim.fn.strdisplaywidth(text)

        table.insert(highlights, { hl = hl, start_col = current_byte, end_col = current_byte + b_len })

        full_text = full_text .. text
        current_byte = current_byte + b_len
        total_display_width = total_display_width + d_len
    end

    add_text(config.style.bar_prefix, config.style.border_hl)

    for i = 1, total_tabs do
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
            display_name = vim.fn.fnamemodify(bufname, ":p:h:t")
        end

        local hl = is_selected and config.style.active_hl or config.style.inactive_hl

        add_text(config.style.tab_prefix, hl)
        if is_selected then
            add_text(config.style.selected_indicator, config.style.indicator_hl)
        else
            add_text(config.style.unselected_indicator, config.style.indicator_hl)
        end
        add_text(tabnr .. ": " .. display_name, hl)
        add_text(config.style.tab_postfix, hl)

        if i < total_tabs then
            add_text(config.style.separator, config.style.separator_hl)
        end
    end

    add_text(config.style.bar_postfix, config.style.border_hl)

    if total_display_width == 0 then
        return
    end

    if not float_buf or not vim.api.nvim_buf_is_valid(float_buf) then
        float_buf = vim.api.nvim_create_buf(false, true)
    end

    vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { full_text })
    vim.api.nvim_buf_clear_namespace(float_buf, ns_id, 0, -1)

    for _, hl in ipairs(highlights) do
        vim.api.nvim_buf_add_highlight(float_buf, ns_id, hl.hl, 0, hl.start_col, hl.end_col)
    end

    -- Calculate Layout & Positioning Engine
    local max_width = vim.o.columns
    -- Calculate usable editor height (ignoring cmdline and statusline)
    local max_height = vim.o.lines - vim.o.cmdheight - (vim.o.laststatus > 0 and 1 or 0)

    local safe_width = math.min(total_display_width, max_width)
    local col_pos = 0
    local row_pos = config.margin.top

    if type(config.position) == "string" then
        -- Horizontal alignment
        if config.position:match("right$") then
            col_pos = max_width - safe_width - config.margin.side
        elseif config.position:match("left$") then
            col_pos = config.margin.side
        elseif config.position:match("center$") then
            col_pos = math.floor((max_width - safe_width) / 2)
        end

        -- Vertical alignment
        if config.position:match("^bottom") then
            row_pos = max_height - 1 - config.margin.top
        end
    elseif type(config.position) == "table" then
        -- Percentage based positioning (0.0 to 1.0)
        local row_pct = math.max(0, math.min(1, config.position.row or 0))
        local col_pct = math.max(0, math.min(1, config.position.col or 0))

        row_pos = math.floor((max_height - 1) * row_pct) + config.margin.top
        col_pos = math.floor((max_width - safe_width) * col_pct)
    end

    -- Check for Overlap (Auto-hiding)
    local should_hide = false

    -- Cursor Overlap & Cursorline Toggle
    if config.auto_hide.cursor_overlap then
        local s_row = vim.fn.screenrow() - 1
        local s_col = vim.fn.screencol() - 1

        -- Toggle cursorline based on dynamic row_pos
        if vim.g.default_cursor_line_mode then
            if s_row == row_pos then
                vim.o.cursorline = false
            else
                vim.o.cursorline = true
            end
        end

        if s_row == row_pos and s_col >= col_pos and s_col <= (col_pos + safe_width) then
            should_hide = true
        end
    end

    -- Text Overlap
    if config.auto_hide.text_overlap and not should_hide then
        -- Only check text overlap if the widget is near the top of the screen
        if row_pos <= 2 then
            local current_win = vim.api.nvim_get_current_win()
            local win_info = vim.fn.getwininfo(current_win)[1]

            if win_info then
                local top_line_nr = vim.fn.line("w0") + row_pos
                local text_content = vim.fn.getline(top_line_nr)
                local total_line_width = vim.fn.strdisplaywidth(text_content) + win_info.textoff

                -- Check if text runs under the widget
                if
                    total_line_width >= col_pos
                    and (total_line_width <= (col_pos + safe_width) or col_pos < total_line_width)
                then
                    should_hide = true
                end
            end
        end
    end

    local win_opts = {
        relative = "editor",
        width = safe_width,
        height = 1,
        row = row_pos,
        col = col_pos,
        style = "minimal",
        focusable = false,
        zindex = 250,
        hide = should_hide,
        border = "none",
    }

    if float_win and vim.api.nvim_win_is_valid(float_win) then
        if vim.api.nvim_win_get_tabpage(float_win) == vim.api.nvim_get_current_tabpage() then
            vim.api.nvim_win_set_config(float_win, win_opts)
        else
            pcall(vim.api.nvim_win_close, float_win, true)
            float_win = vim.api.nvim_open_win(float_buf, false, win_opts)
            vim.api.nvim_set_option_value("winhl", "NormalFloat:FloatingTabsBorder", { win = float_win })
        end
    else
        float_win = vim.api.nvim_open_win(float_buf, false, win_opts)
        vim.api.nvim_set_option_value("winhl", "NormalFloat:FloatingTabsBorder", { win = float_win })
    end
end

function FloatingTabs.setup(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})
    if config.reserve_top_space then
        vim.o.showtabline = 2
        vim.o.tabline = "%#Normal# "
    else
        vim.o.showtabline = 0
    end

    -- Default fallbacks
    vim.api.nvim_set_hl(0, "FloatingTabsActive", { default = true, link = "TabLineSel" })
    vim.api.nvim_set_hl(0, "FloatingTabsInactive", { default = true, link = "TabLine" })
    vim.api.nvim_set_hl(0, "FloatingTabsBorder", { default = true, link = "TabLineFill" })
    vim.api.nvim_set_hl(0, "FloatingTabsIndicator", { default = true, link = "Title" })
    vim.api.nvim_set_hl(0, "FloatingTabsSeparator", { default = true, link = "TabLine" })

    vim.api.nvim_create_autocmd({
        "TabEnter",
        "TabClosed",
        "TabNew",
        "BufEnter",
        "VimResized",
        "CursorMoved",
        "CursorMovedI",
        "WinScrolled",
    }, {
        group = tab_group,
        callback = function()
            vim.schedule(draw_floating_tabs)
        end,
    })

    vim.schedule(draw_floating_tabs)
end

function FloatingTabs.redraw()
    draw_floating_tabs()
end

return FloatingTabs
