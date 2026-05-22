local M = {}

-- =============================================================================
-- UTILITY FUNCTIONS
-- =============================================================================

local function is_dir(path)
    local stat = vim.uv.fs_stat(path)
    return stat and stat.type == "directory"
end

local function execute_jump(path, is_directory)
    if not path then
        return
    end
    local full_path = vim.fn.expand(path)

    if is_directory then
        require("oil").open(full_path)
        vim.schedule(function()
            vim.cmd("tcd " .. vim.fn.fnameescape(full_path))
            vim.t.tabname = vim.fn.fnamemodify(full_path, ":t")
            vim.cmd("redrawtabline")
        end)
    else
        vim.cmd("edit " .. vim.fn.fnameescape(full_path))
    end
end

local function clear_prompt(picker)
    local win_id = picker.input.win.win
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, { "" })
    picker:filter():init({ pattern = "", search = "" })
end

-- =============================================================================
-- DECLARATIVE BASE PICKER OPTIONS CONFIGURATION (DEFINED OUTSIDE)
-- =============================================================================

local base_opts = {
    title = "File Navigator",
    layout = { preset = "ivy", preview = true },
    dirs_only = false,
    hidden = false,
    ignored = true,
    toggles = { dirs_only = "d", hidden = "h", ignored = "i" },
    sort = { empty = false },
    matcher = { cwd_bonus = true, filename_bonus = true },

    finder = function(picker_opts, ctx)
        local current_cwd = ctx.picker:cwd()
        local base_args =
            "--absolute-path --max-depth 1 --exclude .git --exclude __pycache__ --exclude wandb/ --exclude .build/"
        if ctx.picker.opts.ignored then
            base_args = base_args .. " --no-ignore"
        end

        local cmds = {}
        local function append_fd(type_args, is_hidden)
            if is_hidden then
                table.insert(cmds, string.format("fd %s '^\\.' --hidden %s", type_args, base_args))
            else
                table.insert(cmds, string.format("fd %s '^[^.]' %s", type_args, base_args))
            end
        end

        if ctx.picker.opts.dirs_only then
            if ctx.picker.opts.hidden then
                append_fd("--type d", true)
            end
            append_fd("--type d", false)
        else
            if ctx.picker.opts.hidden then
                append_fd("--type d", true)
            end
            append_fd("--type d", false)
            if ctx.picker.opts.hidden then
                append_fd("--type f --type l", true)
            end
            append_fd("--type f --type l", false)
        end

        return require("snacks.picker.source.proc").proc({
            cmd = "sh",
            args = { "-c", table.concat(cmds, " ; ") },
            cwd = current_cwd,
        }, ctx)
    end,

    transform = function(item)
        local clean_path = item.text:gsub("/$", "")
        item.file = clean_path

        if is_dir(clean_path) then
            item.dir = true
            item.text = vim.fn.fnamemodify(clean_path, ":t") .. "/"
        else
            item.dir = false
            item.text = vim.fn.fnamemodify(clean_path, ":t")
        end
        return item
    end,

    actions = {
        toggle_dir_mode = function(picker)
            picker.opts.dirs_only = not picker.opts.dirs_only
            picker:find()
        end,
        toggle_hidden_mode = function(picker)
            picker.opts.hidden = not picker.opts.hidden
            picker:find()
        end,
        toggle_ignored_mode = function(picker)
            picker.opts.ignored = not picker.opts.ignored
            picker:find()
        end,

        force_create_file = function(picker)
            local pattern = vim.trim(picker:filter().pattern)
            if pattern == "" then
                return
            end

            picker:close()
            local current_cwd = picker:cwd()
            local base_cwd = current_cwd == "/" and "/" or current_cwd .. "/"
            local target_path = base_cwd .. pattern:gsub("/$", "")

            local parent = vim.fn.fnamemodify(target_path, ":h")
            if vim.fn.isdirectory(parent) == 0 then
                vim.fn.mkdir(parent, "p")
            end
            execute_jump(target_path, false)
        end,

        confirm_or_create = function(picker)
            local item = picker:current()
            local pattern = vim.trim(picker:filter().pattern)
            local current_cwd = picker:cwd()
            local base_cwd = current_cwd == "/" and "/" or current_cwd .. "/"

            if pattern ~= "" and pattern:match("/$") then
                picker:close()
                local clean_pattern = pattern:gsub("/$", "")
                local target_path = base_cwd .. clean_pattern
                vim.fn.mkdir(target_path, "p")
                execute_jump(target_path, true)
                return
            end

            if item then
                if not item.dir then
                    picker:close()
                    execute_jump(item.file, false)
                    return
                end

                if item.dir then
                    local dirname = vim.fn.fnamemodify(item.file, ":t")
                    if pattern == "" or pattern:lower() == dirname:lower() then
                        picker:close()
                        execute_jump(item.file, true)
                        return
                    end
                end
            end

            if pattern ~= "" then
                picker:close()
                local target_path = base_cwd .. pattern
                local parent = vim.fn.fnamemodify(target_path, ":h")
                if vim.fn.isdirectory(parent) == 0 then
                    vim.fn.mkdir(parent, "p")
                end
                execute_jump(target_path, false)
                return
            end

            picker:close()
        end,

        dir_down = function(picker)
            local item = picker:current()
            local pattern = vim.trim(picker:filter().pattern)

            if item and item.dir then
                local dirname = vim.fn.fnamemodify(item.file, ":t")
                if pattern:lower() == dirname:lower() then
                    local new_cwd = item.file
                    picker:set_cwd(new_cwd)
                    picker.opts.prompt = vim.fn.fnamemodify(new_cwd, ":~") .. (new_cwd == "/" and "" or "/")
                    clear_prompt(picker)
                    picker:find()
                    return
                end
            end
            vim.api.nvim_feedkeys("/", "n", false)
        end,

        accept = function(picker)
            local item = picker:current()
            if item and item.dir then
                local new_cwd = item.file
                picker:set_cwd(new_cwd)
                picker.opts.prompt = vim.fn.fnamemodify(new_cwd, ":~") .. (new_cwd == "/" and "" or "/")
                clear_prompt(picker)
                picker:find()
            end
        end,

        dir_up = function(picker)
            local parent_dir = vim.fn.fnamemodify(picker:cwd(), ":h")
            picker:set_cwd(parent_dir)
            picker.opts.prompt = vim.fn.fnamemodify(parent_dir, ":~") .. (parent_dir == "/" and "" or "/")
            clear_prompt(picker)
            picker:find()
        end,

        dir_up_input_m = function(picker)
            if picker:filter().pattern == "" then
                local parent_dir = vim.fn.fnamemodify(picker:cwd(), ":h")
                picker:set_cwd(parent_dir)
                picker.opts.prompt = vim.fn.fnamemodify(parent_dir, ":~") .. (parent_dir == "/" and "" or "/")
                clear_prompt(picker)
                picker:find()
            else
                local backspace = vim.api.nvim_replace_termcodes("<BS>", true, false, true)
                vim.api.nvim_feedkeys(backspace, "n", false)
            end
        end,

        open_pwd_in_oil = function(picker)
            picker:close()
            execute_jump(picker:cwd(), true)
        end,
    },

    win = {
        input = {
            keys = {
                ["<CR>"] = { "confirm_or_create", mode = { "n", "i" } },
                ["<C-CR>"] = { "force_create_file", mode = { "i", "n" } },
                ["<Tab>"] = { "accept", mode = { "i" } },
                ["/"] = { "dir_down", mode = { "i" } },
                ["<BS>"] = { "dir_up_input_m", mode = { "i" } },
                ["<C-o>"] = { "open_pwd_in_oil", mode = { "n", "i" } },
                ["-"] = { "dir_up", mode = { "n" } },
                ["<C-t>p"] = { "toggle_preview", mode = { "n", "i" } },
                ["<C-t>d"] = { "toggle_dir_mode", mode = { "n", "i" } },
                ["<C-t>h"] = { "toggle_hidden_mode", mode = { "n", "i" } },
                ["<C-t>i"] = { "toggle_ignored_mode", mode = { "n", "i" } },
            },
        },
    },
}

-- =============================================================================
-- EXECUTABLE PICKER INVOCATIONS
-- =============================================================================

M.open_file_navigator = function(opts)
    opts = opts or {}
    local initial_cwd = opts.cwd or vim.fn.getcwd()

    -- Clean up initialization-only parameters so they don't corrupt snacks parsing layers
    opts.cwd = nil

    -- 1. Construct contextual parameters
    local structural_defaults = {
        cwd = initial_cwd,
        prompt = vim.fn.fnamemodify(initial_cwd, ":~") .. (initial_cwd == "/" and "" or "/"),
    }

    -- 2. Cleanly merge: base architecture options -> runtime adjustments -> structural contexts
    local final_opts = vim.tbl_deep_extend("force", {}, base_opts, opts, structural_defaults)

    require("snacks").picker(final_opts)
end

M.open_folder_picker = function(opts)
    opts = opts or {}

    -- Define explicit overrides targeting your loose-matching folder search requirement
    local search_overrides = {
        title = "Folder Navigator",
        dirs_only = true,
        ignore = true,
        hidden = true,
        actions = {
            folder_search_confirm = function(picker)
                local item = picker:current()
                if item and item.dir then
                    picker:close()
                    execute_jump(item.file, true)
                    return
                end
                picker:close()
            end,

            folder_search_dir_down = function(picker)
                local item = picker:current()
                if item and item.dir then
                    local new_cwd = item.file
                    picker:set_cwd(new_cwd)
                    picker.opts.prompt = vim.fn.fnamemodify(new_cwd, ":~") .. (new_cwd == "/" and "" or "/")
                    clear_prompt(picker)
                    picker:find()
                    return
                end
                vim.api.nvim_feedkeys("/", "n", false)
            end,
        },
        win = {
            input = {
                keys = {
                    ["<CR>"] = { "folder_search_confirm", mode = { "n", "i" } },
                    ["/"] = { "folder_search_dir_down", mode = { "i" } },
                },
            },
        },
    }

    -- Merge incoming arguments directly on top of our isolated structural overrides
    local unified_opts = vim.tbl_deep_extend("force", {}, search_overrides, opts)

    M.open_file_navigator(unified_opts)
end

M.smart_dir_jump = function()
    local snacks = require("snacks")

    local function open_oil(path)
        if not path then
            return
        end
        local full_path = vim.fn.expand(path)
        require("oil").open(full_path)
        vim.schedule(function()
            vim.cmd("tcd " .. vim.fn.fnameescape(full_path))
            vim.t.tabname = vim.fn.fnamemodify(full_path, ":t")
            vim.cmd("redrawtabline")
        end)
    end

    snacks.picker.pick("zoxide", {
        title = "Smart Jump (Zoxide)",
        layout = { preset = "ivy", preview = false },
        win = {
            input = {
                keys = {
                    ["<CR>"] = { "smart_confirm", mode = { "i", "n" } },
                    ["<c-d>"] = { "force_discover", mode = { "i", "n" } },
                },
            },
        },
        actions = {
            smart_confirm = function(picker, item)
                if not item then
                    picker:close()
                    M.open_file_navigator({
                        title = "Zoxide Folder Discovery",
                        cwd = vim.fn.expand("$HOME"),
                        show_hidden = true,
                    })
                else
                    picker:close()
                    execute_jump(item.file or item.text, true)
                end
            end,
            force_discover = function(picker)
                picker:close()
                M.open_file_navigator({
                    title = "Zoxide Folder Discovery",
                    cwd = vim.fn.expand("$HOME"),
                    show_hidden = true,
                })
            end,
        },
    })
end

return M
