vim.o.winborder = "rounded"

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

vim.lsp.enable("lua-language-server")
vim.lsp.enable("pyright")
vim.lsp.enable("clangd")

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
    },
})
require("blink.cmp.config").completion.menu.auto_show = false
