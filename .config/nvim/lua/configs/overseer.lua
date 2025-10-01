require("overseer").setup({
  -- Default task strategy
  strategy = "terminal",
  -- Template modules to load
  templates = { "builtin" },
  -- Directories where overseer will look for template definitions (relative to rtp)
  template_dirs = { "overseer.template" },
  -- When true, tries to detect a green color from your colorscheme to use for success highlight
  auto_detect_success_color = true,
  -- Patch nvim-dap to support preLaunchTask and postDebugTask
  dap = true,
  -- Configure the task list
  task_list = {
    default_detail = 2,
    max_width = { 100, 0.2 },
    min_width = { 80, 0.1 },
    -- optionally define an integer/float for the exact width of the task list
    width = nil,
    max_height = { 90, 0.1 },
    min_height = 90,
    height = nil,
    -- String that separates tasks
    separator = "────────────────────────────────────────",
    -- Default direction. Can be "left", "right", or "bottom"
    direction = "bottom",
    -- Set keymap to false to remove default behavior
    -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
    bindings = {
      ["?"] = "ShowHelp",
      ["g?"] = "ShowHelp",
      ["<CR>"] = "RunAction",
      ["<C-e>"] = "Edit",
      ["o"] = "Open",
      ["<C-v>"] = "OpenVsplit",
      ["<C-s>"] = "OpenSplit",
      ["<C-f>"] = "OpenFloat",
      ["<C-q>"] = "OpenQuickFix",
      ["p"] = "TogglePreview",
      ["<C-l>"] = "IncreaseDetail",
      ["<C-h>"] = "DecreaseDetail",
      ["L"] = "IncreaseAllDetail",
      ["H"] = "DecreaseAllDetail",
      ["["] = "DecreaseWidth",
      ["]"] = "IncreaseWidth",
      ["{"] = "PrevTask",
      ["}"] = "NextTask",
      ["<C-k>"] = "ScrollOutputUp",
      ["<C-j>"] = "ScrollOutputDown",
      ["q"] = "Close",
    },
  },
  -- See :help overseer-actions
  actions = {},
  -- Configure the floating window used for task templates that require input
  -- and the floating window used for editing tasks
  form = {
    border = "rounded",
    zindex = 40,
    -- Dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_X and max_X can be a single value or a list of mixed integer/float types.
    min_width = 80,
    max_width = 0.9,
    width = nil,
    min_height = 10,
    max_height = 0.9,
    height = nil,
    -- Set any window options here (e.g. winhighlight)
    win_opts = {
      winblend = 0,
    },
  },
  task_launcher = {
    -- Set keymap to false to remove default behavior
    -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
    bindings = {
      i = {
        ["<C-s>"] = "Submit",
        ["<C-c>"] = "Cancel",
      },
      n = {
        ["<CR>"] = "Submit",
        ["<C-s>"] = "Submit",
        ["q"] = "Cancel",
        ["?"] = "ShowHelp",
      },
    },
  },
  task_editor = {
    -- Set keymap to false to remove default behavior
    -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
    bindings = {
      i = {
        ["<CR>"] = "NextOrSubmit",
        ["<C-s>"] = "Submit",
        ["<Tab>"] = "Next",
        ["<S-Tab>"] = "Prev",
        ["<C-c>"] = "Cancel",
      },
      n = {
        ["<CR>"] = "NextOrSubmit",
        ["<C-s>"] = "Submit",
        ["<Tab>"] = "Next",
        ["<S-Tab>"] = "Prev",
        ["q"] = "Cancel",
        ["?"] = "ShowHelp",
      },
    },
  },
  -- Configure the floating window used for confirmation prompts
  confirm = {
    border = "rounded",
    zindex = 40,
    -- Dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_X and max_X can be a single value or a list of mixed integer/float types.
    min_width = 20,
    max_width = 0.5,
    width = nil,
    min_height = 6,
    max_height = 0.9,
    height = nil,
    -- Set any window options here (e.g. winhighlight)
    win_opts = {
      winblend = 0,
    },
  },
  -- Configuration for task floating windows
  task_win = {
    -- How much space to leave around the floating window
    padding = 2,
    border = "rounded",
    -- Set any window options here (e.g. winhighlight)
    win_opts = {
      winblend = 0,
    },
  },
  -- Configuration for mapping help floating windows
  help_win = {
    border = "rounded",
    win_opts = {},
  },
  -- Aliases for bundles of components. Redefine the builtins, or create your own.
  component_aliases = {
    -- Most tasks are initialized with the default components
    default = {
      { "display_duration", detail_level = 2 },
      "on_output_summarize",
      "on_exit_set_status",
      "on_complete_notify",
      { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
    },
    -- Tasks from tasks.json use these components
    default_vscode = {
      "default",
      "on_result_diagnostics",
    },
  },
  bundles = {
    -- When saving a bundle with OverseerSaveBundle or save_task_bundle(), filter the tasks with
    -- these options (passed to list_tasks())
    save_task_opts = {
      bundleable = true,
    },
    -- Autostart tasks when they are loaded from a bundle
    autostart_on_load = true,
  },
  -- A list of components to preload on setup.
  -- Only matters if you want them to show up in the task editor.
  preload_components = {},
  -- Controls when the parameter prompt is shown when running a template
  --   always    Show when template has any params
  --   missing   Show when template has any params not explicitly passed in
  --   allow     Only show when a required param is missing
  --   avoid     Only show when a required param with no default value is missing
  --   never     Never show prompt (error if required param missing)
  default_template_prompt = "allow",
  -- For template providers, how long to wait (in ms) before timing out.
  -- Set to 0 to disable timeouts.
  template_timeout = 3000,
  -- Cache template provider results if the provider takes longer than this to run.
  -- Time is in ms. Set to 0 to disable caching.
  template_cache_threshold = 100,
  -- Configure where the logs go and what level to use
  -- Types are "echo", "notify", and "file"
  log = {
    {
      type = "echo",
      level = vim.log.levels.WARN,
    },
    {
      type = "file",
      filename = "overseer.log",
      level = vim.log.levels.WARN,
    },
  },
})
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

function get_compiler_args(chosen_compiler)
    if chosen_compiler == "latexmk" then
        return { "-pdf", "-interaction=nonstopmode", "main.tex" }
    else
        return { "main.tex" }
    end
end

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
            -- args = { vim.fn.expand("%") },
            args = get_compiler_args(chosen_compiler),
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
            items = { { text = "latexmk" }, { text = "pdflatex" }, { text = "XeLaTeX" } },
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
    pattern = { "tex", "plaintex" },
    callback = function()
        vim.keymap.set("n", "<leader>cc", function()
            vim.cmd("write") -- save buffer
            ensure_compiler_and_run()
        end, { buffer = true, desc = "Compile LaTeX" })
    end,
})
