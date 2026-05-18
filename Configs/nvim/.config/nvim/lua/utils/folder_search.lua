local M = {}

local function is_dir(path)
    local stat = vim.uv.fs_stat(path)
    return stat and stat.type == "directory"
end

local function has_subfolders(path)
    local handle = vim.uv.fs_scandir(path)
    if not handle then
        return false
    end
    while true do
        local name, type = vim.uv.fs_scandir_next(handle)
        if not name then
            break
        end
        if type == "directory" and name ~= ".git" and name ~= "__pycache__" then
            return true
        end
    end
    return false
end

M.open_folder_picker = function(opts)
    opts = opts or {}
    local initial_cwd = opts.cwd or vim.fn.getcwd()
    local snacks = require("snacks")

    local function clear_prompt(picker)
        -- First, wipe the physical UI buffer so it stops "pushing" the old text
        local win_id = picker.input.win.win
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, { "" })

        -- Second, reset the filter object using its internal init
        picker:filter():init({ pattern = "", search = "" })

        -- Third, tell the picker to update the results list
        picker:find()
    end

    snacks.picker({
        finder = "files",
        cmd = "fd",
        args = {
            "--type",
            "d",
            "--hidden",
            "--no-ignore",
            "--exclude",
            ".git",
            "--exclude",
            "wandb/",
            "--exclude",
            ".build/",
            "--exclude",
            "__pycache__",
            "--absolute-path",
            "--max-depth",
            "1",
        },
        layout = { preview = false },
        cwd = initial_cwd,
        prompt = vim.fn.fnamemodify(initial_cwd, ":~") .. (initial_cwd == "/" and ""  or "/"),
        matcher = {
            cwd_bonus = true,
            filename_bonus = true,
        },
        formatters = {
            file = {
                filename_first = true,
            },
        },
        transform = function(item)
            if is_dir(item.text) then
                local clean_path = item.text:gsub("/$", "")
                item.file = clean_path
                item.dir = true
                item.text = vim.fn.fnamemodify(clean_path, ":t")
                return item
            else
                return false
            end
        end,
        actions = {
            dir_down = function(picker)
                local item = picker:current()
                if item and item.dir then
                    local new_cwd = item.file
                    if not has_subfolders(new_cwd) then
                        picker:close()
                        require("oil").open(new_cwd)
                        return
                    end
                    picker:set_cwd(new_cwd)
                    picker.opts.prompt = vim.fn.fnamemodify(new_cwd, ":~") .. (new_cwd == "/" and ""  or "/")
                    clear_prompt(picker)
                    picker:find()
                end
            end,

            dir_up = function(picker)
                local item = picker:current()
                local parent_dir = vim.fn.fnamemodify(picker:cwd(), ":h")
                picker:set_cwd(parent_dir)
                picker.opts.prompt = vim.fn.fnamemodify(parent_dir, ":~") .. (parent_dir == "/" and ""  or "/")
                clear_prompt(picker)
                picker:find()
            end,

            dir_up_input_m = function(picker)
                if picker:filter().pattern == "" then
                    local item = picker:current()
                    local parent_dir = vim.fn.fnamemodify(picker:cwd(), ":h")
                    picker:set_cwd(parent_dir)
                    picker.opts.prompt = vim.fn.fnamemodify(parent_dir, ":~") .. (parent_dir == "/" and ""  or "/")
                    clear_prompt(picker)
                    picker:find()
                else
                    local backspace = vim.api.nvim_replace_termcodes("<BS>", true, false, true)
                    vim.api.nvim_feedkeys(backspace, "n", false)
                end
            end,

            open_pwd_in_oil = function(picker)
                picker:close()
                require("oil").open(picker:cwd())
            end,

            open_selected_in_oil = function(picker)
                local item = picker:current()
                if item and item.dir then
                    picker:close()
                    require("oil").open(item.file)
                end
            end,
        },
        win = {
            input = {
                keys = {
                    ["<CR>"] = { "dir_down", mode = { "n", "i" } },
                    ["/"] = { "dir_down", mode = { "i" } },
                    ["<BS>"] = { "dir_up_input_m", mode = { "i" } },
                    ["<C-o>"] = { "open_pwd_in_oil", mode = { "n", "i" } },
                    ["<C-e>"] = { "open_selected_in_oil", mode = { "n", "i" } },
                    ["-"] = { "dir_up", mode = { "n" } },
                },
            },
        },
    })
end

M.smart_dir_jump = function()
    local has_snacks, snacks = pcall(require, "snacks")
    if not has_snacks then
        return
    end

    local function jump_and_oil(picker, item)
        picker:close()
        local path = item and (item.file or item.dir or item.text)
        if path then
            vim.cmd("tcd " .. vim.fn.fnameescape(path))
            -- Set the tab name to the folder name
            vim.t.tabname = vim.fn.fnamemodify(path, ":t")
            require("oil").open(path)
            -- Force tabline update
            vim.cmd("redrawtabline")
        end
    end

    local function trigger_discovery(picker)
        local query = picker.input.filter.pattern
        picker:close()
        snacks.picker.pick({
            title = "Discovery (FD)",
            layout = "ivy",
            search = query,
            finder = "proc",
            cmd = "fd",
            args = {
                "--type",
                "d",
                "--max-depth",
                "4",
                "--hidden",
                "--exclude",
                ".git",
                "--exclude",
                ".cache",
                "--absolute-path",
            },
            cwd = vim.fn.expand("$HOME"),
            transform = function(item)
                item.file = item.text
                item.dir = true
            end,
            confirm = jump_and_oil,
        })
    end

    snacks.picker.pick("zoxide", {
        title = "Smart Jump (Zoxide)",
        layout = "ivy",
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
                    trigger_discovery(picker)
                else
                    jump_and_oil(picker, item)
                end
            end,
            force_discover = function(picker)
                trigger_discovery(picker)
            end,
        },
    })
end

return M
