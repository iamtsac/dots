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

vim.lsp.enable("lua-language-server")
vim.lsp.enable("pyright")
vim.lsp.enable("clangd")
vim.lsp.enable("texlab")
vim.lsp.enable("harper_ls")
vim.lsp.enable("ltex_plus")

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
    completion = {
        keyword = { range = "full" },
        -- menu = {
        --     auto_show = false,
        -- },
        list = { selection = { preselect = false, auto_insert = true } },
    },
    cmdline = { enabled = false },
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
