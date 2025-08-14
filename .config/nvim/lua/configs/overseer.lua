require("overseer").setup()
local overseer = require("overseer")

-- ==== Project-based compiler persistence ====
local chosen_compiler = nil
local compiler_file = nil

local function get_tmp_file()
    local project_root = vim.fn.getcwd()
    local hash = vim.fn.sha256(project_root):sub(1, 8)
    local tmp_dir = os.getenv("HOME") .. "/.local/state/nvim/latex_compilers"
    vim.fn.mkdir(tmp_dir, "p")
    return tmp_dir .. "/" .. hash
end

local function save_compiler(compiler)
    local f = io.open(compiler_file, "w")
    if f then
        f:write(compiler)
        f:close()
    end
end

local function load_compiler()
    local f = io.open(compiler_file, "r")
    if f then
        local saved = f:read("*l")
        f:close()
        return saved
    end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        os.remove(get_tmp_file())
    end,
})

overseer.register_template({
    name = "Compile TeX",
    builder = function()
        if not compiler_file then
            compiler_file = get_tmp_file()
        end
        if not chosen_compiler then
            chosen_compiler = load_compiler()
        end
        -- Now we are guaranteed to have a compiler
        return {
            cmd = { chosen_compiler },
            args = { vim.fn.expand("%") },
        }
    end,
})

local function ensure_compiler_and_run()
    if not compiler_file then
        compiler_file = get_tmp_file()
    end
    if not chosen_compiler then
        chosen_compiler = load_compiler()
    end
    if not chosen_compiler then
        require("snacks").picker({
            title = "Select LaTeX Compiler",
            items = { { text = "pdflatex" }, { text = "XeLaTeX" } },
            format = "text",
            layout = {
                preset = "default",
                preview = false,
            },
            confirm = function(picker, item)
                chosen_compiler = item.text
                save_compiler(chosen_compiler)
                picker:close()
                -- Compiler is chosen → run Overseer template
                overseer.run_template({ name = "Compile TeX" })
                vim.g.compiler = chosen_compiler
            end,
        })
    else
        -- Already have compiler → run directly
        overseer.run_template({ name = "Compile TeX" })
    end
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function()
        vim.keymap.set("n", "<leader>cc", function()
            vim.cmd("write") -- save buffer
            ensure_compiler_and_run()
        end, { buffer = true, desc = "Compile LaTeX" })
    end,
})
