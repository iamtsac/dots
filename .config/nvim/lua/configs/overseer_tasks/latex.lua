local overseer = require("overseer")

-- ==== Persistence Logic ====
local chosen_compiler = nil
local chosen_main_file = nil

-- Generates a unique path for caching based on project root + a suffix (e.g., "compiler" or "mainfile")
local function get_cache_path(suffix)
  local project_root = vim.fn.getcwd()
  local hash = vim.fn.sha256(project_root):sub(1, 8)
  local tmp_dir = os.getenv("HOME") .. "/.local/state/nvim/latex_compilers"
  vim.fn.mkdir(tmp_dir, "p")
  return string.format("%s/%s_%s", tmp_dir, hash, suffix)
end

local function save_cache(suffix, value)
  local f = io.open(get_cache_path(suffix), "w")
  if f then
    f:write(value)
    f:close()
  end
end

local function load_cache(suffix)
  local f = io.open(get_cache_path(suffix), "r")
  if f then
    local saved = f:read("*l")
    f:close()
    return saved
  end
end

local function clear_cache(suffix)
  os.remove(get_cache_path(suffix))
end

-- Cleanup on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    clear_cache("compiler")
    clear_cache("mainfile")
  end,
})

-- ==== Overseer Template ====
overseer.register_template({
  name = "Compile TeX",
  params = {
    file = { type = "string", desc = "The LaTeX file to compile" },
  },
  builder = function(params)
    -- Load state if not in memory (redundant safety check)
    if not chosen_compiler then chosen_compiler = load_cache("compiler") end

    local cmd_args = { params.file }
    if chosen_compiler == "latexmk" then
      table.insert(cmd_args, 1, "-interaction=nonstopmode")
      table.insert(cmd_args, 1, "-pdf")
    end

    return {
      cmd = { chosen_compiler },
      args = cmd_args,
    }
  end,
})

-- ==== Runner Logic ====

-- Final step: Actually run the task
local function run_overseer_task()
  overseer.run_task({
    name = "Compile TeX",
    params = { file = chosen_main_file }
  })
end

-- Step 2: Ensure File is selected
local function ensure_file_and_run()
  if not chosen_main_file then
    chosen_main_file = load_cache("mainfile")
  end

  if chosen_main_file then
    -- File is already known/saved, run immediately
    run_overseer_task()
  else
    -- Open Picker to select file
    require("snacks").picker.files({
      title = "Select TeX File",
      -- Filter strictly for .tex files using fd arguments
      cmd = "fd", 
      args = { "-e", "tex", "--type", "f" },
      confirm = function(picker, item)
        picker:close()
        if item then
          chosen_main_file = item.file or item.text
          save_cache("mainfile", chosen_main_file)
          run_overseer_task()
        end
      end
    })
  end
end

-- Step 1: Ensure Compiler is selected
local function ensure_compiler_then_run()
  if not chosen_compiler then
    chosen_compiler = load_cache("compiler")
  end

  if chosen_compiler then
    ensure_file_and_run()
  else
    require("snacks").picker({
      title = "Select LaTeX Compiler",
      items = { { text = "latexmk" }, { text = "pdflatex" }, { text = "XeLaTeX" } },
      format = "text",
      layout = { preset = "default", preview = false },
      confirm = function(picker, item)
        chosen_compiler = item.text
        save_cache("compiler", chosen_compiler)
        picker:close()
        vim.g.compiler = chosen_compiler
        ensure_file_and_run()
      end,
    })
  end
end

-- ==== Keymaps ====

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex" },
  callback = function()
    -- Normal Compile: Uses cached compiler and cached file if available
    vim.keymap.set("n", "<leader>cc", function()
      vim.cmd("write")
      ensure_compiler_then_run()
    end, { buffer = true, desc = "Compile LaTeX" })

    -- Reset Main File: Clears the memory so you can pick a different file
    vim.keymap.set("n", "<leader>cR", function()
      chosen_main_file = nil
      clear_cache("mainfile")
      vim.notify("Cleared cached LaTeX file. Run <leader>cc to select a new one.", vim.log.levels.INFO)
    end, { buffer = true, desc = "Reset LaTeX Args" })
  end,
})
