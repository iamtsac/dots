local blink = require("blink.cmp")
local capabilities = blink.get_lsp_capabilities()
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-8" }
vim.lsp.config("*", { capabilities = capabilities })

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
            -- Disable hover in favor of Pyright (if you use it)
            client.server_capabilities.hoverProvider = false
        end
    end,
}

vim.lsp.config("basedpyright", {
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
    on_init = function(client)
        client.config.settings.python.pythonPath = vim.fn.exepath("python")
    end,
    settings = {
        python = {
            analysis = {
                diagnosticMode = "workspace",
                indexing = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
})

vim.lsp.config("ty", {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", "ty.toml", ".git" },
    capabilities = capabilities,
    on_init = function(client)
        client.config.settings.python.pythonPath = vim.fn.exepath("python")
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
    appearance = {
        nerd_font_variant = "normal",
    },
    fuzzy = { implementation = "prefer_rust" },
    keymap = { preset = "cmdline" },
    completion = {
        keyword = { range = "full" },
        list = { selection = { preselect = false, auto_insert = true } },
        menu = { auto_show = true },
        ghost_text = { enabled = false },
    },
    signature = { enabled = true },
    keymap = {
        ["<C-k>"] = { "scroll_documentation_up", "fallback" },
        ["<C-j>"] = { "scroll_documentation_down", "fallback" },
        ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },
    },
    cmdline = { enabled=true, completion = { ghost_text = { enabled = true } } }
})
-- require("blink.cmp.config").completion.menu.auto_show = false

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
            if winid ~= -1 then
                -- 1. Ensure conceal is active
                vim.wo[winid].conceallevel = 2
                vim.wo[winid].concealcursor = "nc"
                -- 2. Manually define a syntax match to conceal the backticks
                -- This targets the backticks and the language name (e.g., ```python)
                vim.fn.matchadd("Conceal", [[^```\w*]], 10, -1, { conceal = "" })
                vim.fn.matchadd("Conceal", [[^```$]], 10, -1, { conceal = "" })
            end
        end
    end,
})
