local blink = require("blink.cmp")
local capabilities = blink.get_lsp_capabilities()
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-16" }
vim.lsp.config("*", { capabilities = capabilities })

local function get_python_path(root_dir)
    local pixi_prefix = os.getenv("CONDA_PREFIX") or (root_dir .. "/.pixi/envs/default")
    local pixi_python = pixi_prefix .. "/bin/python"

    if vim.fn.executable(pixi_python) == 1 then
        return pixi_python
    end

    local venv_python = root_dir .. "/.venv/bin/python"
    if vim.fn.executable(venv_python) == 1 then
        return venv_python
    end

    return vim.fn.exepath("python3") or vim.fn.exepath("python")
end

vim.lsp.config["lua-language-server"] = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    vim.env.VIMRUNTIME .. "/lua",
                },
            },
        },
    },
}

vim.lsp.config["harper_ls"] = {
    filetypes = {
        "gitcommit",
        "html",
        "markdown",
        "toml",
        "typst",
        "text",
        -- "latex",
        -- "tex",
        -- "plaintex",
    },
}

vim.lsp.config["ltex_plus"] = {

    filetypes = {
        "bib",
        "plaintex",
        "rst",
        "rnoweb",
        "tex",
        -- "pandoc",
        -- "quarto",
        -- "rmd",
        -- "context",
        -- "html",
        -- "xhtml",
        -- "mail",
        -- "text",
    },
}

vim.lsp.config["ruff"] = {
    init_options = {
        settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
        },
    },
    on_attach = function(client, bufnr)
        if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
        end
    end,
}

vim.lsp.config("basedpyright", {
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
    on_init = function(client)
        -- Leverage the root directory to point basedpyright to your isolated Pixi environment
        local root = client.root_dir or vim.fn.getcwd()
        client.config.settings.python.pythonPath = get_python_path(root)
    end,
    settings = {
        python = {
            analysis = {
                diagnosticMode = "openFilesOnly",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                indexing = true,
            },
        },
    },
})

vim.lsp.config("ty", {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", "ty.toml", "pixi.toml", ".git" },
    capabilities = capabilities,
    on_init = function(client)
        local root = client.root_dir or vim.fn.getcwd()
        client.config.settings.python.pythonPath = get_python_path(root)
    end,
    settings = {
        python = {
            analysis = {
                indexing = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
            },
        },
    },
})

vim.lsp.config("clangd", {
    root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
})

local servers = { "lua-language-server", "basedpyright", "clangd", "texlab", "harper_ls", "ruff" }
for _, server in ipairs(servers) do
    vim.lsp.enable(server)
end

vim.diagnostic.config({
    underline = false,
    virtual_text = false,
})

vim.diagnostic.enable(false)

require("blink.cmp").setup({
    appearance = { nerd_font_variant = "normal" },
    fuzzy = { implementation = "prefer_rust" },
    signature = { enabled = true },

    completion = {
        keyword = { range = "full" },
        menu = { auto_show = true, auto_show_delay_ms = 5 },
        ghost_text = { enabled = false },
        list = { selection = { preselect = false, auto_insert = true } },
    },

    keymap = {
        ["<C-k>"] = { "scroll_documentation_up", "fallback" },
        ["<C-j>"] = { "scroll_documentation_down", "fallback" },
        ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },

    cmdline = {
        enabled = true,
        completion = {
            menu = {
                auto_show = function(ctx)
                    return vim.fn.getcmdtype() == ":"
                end,
                draw = {
                    columns = { { "label", "label_description", gap = 5 } },
                },
            },
            list = { selection = { preselect = true, auto_insert = false } },
        },
        keymap = {
            ["<Tab>"] = { "show", "accept" },
            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
        },
    },
})

vim.api.nvim_create_augroup("TextDiagnostics", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
    group = "TextDiagnostics",
    pattern = { "*.md", "*.tex", "*.txt", "*.typ" },
    callback = function()
        vim.diagnostic.enable(true)
        vim.diagnostic.config({
            underline = true,
            virtual_text = false,
            float = false,
        })
    end,
})

vim.api.nvim_create_autocmd("BufLeave", {
    group = "TextDiagnostics",
    pattern = { "*.md", "*.tex", "*.txt", "*.typ" },
    callback = function()
        vim.diagnostic.enable(false)
        vim.diagnostic.config({
            underline = false,
            virtual_text = false,
        })
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(args)
        if vim.bo[args.buf].buftype == "nofile" then
            local winid = vim.fn.bufwinid(args.buf)
            if winid and winid ~= -1 then
                vim.wo[winid].conceallevel = 2
                vim.wo[winid].concealcursor = "nc"
            end
        end
    end,
})
