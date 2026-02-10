local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "folke/which-key.nvim", dependencies = { "echasnovski/mini.icons", version = false } },
    { "nvim-treesitter/nvim-treesitter", version = false, build = ":TSUpdate" },
    { "folke/snacks.nvim", priority = 1000, lazy = false },
    { "nvim-tree/nvim-web-devicons" },
    { "lewis6991/gitsigns.nvim" },
    { "numToStr/Comment.nvim" },
    { "stevearc/conform.nvim" },
    { "williamboman/mason.nvim" },
    { "neovim/nvim-lspconfig" },
    { "stevearc/oil.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    },
    {
        "Saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        build = "cargo build --release",
    },
    {
        "catgoose/nvim-colorizer.lua",
        lazy = true, -- don't load at startup
        cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" }, -- load when these commands are used
        opts = function()
            require("colorizer").setup()
        end,
    },
    { "stevearc/overseer.nvim" },
    { "webhooked/kanso.nvim", lazy = false, priority = 1000 },
    { "miikanissi/modus-themes.nvim", priority = 1000 },
    { "Mofiqul/vscode.nvim", lazy = false, priority = 1000 },
    { "vague-theme/vague.nvim", lazy = false, priority = 1000 },
    { "dgox16/oldworld.nvim", lazy = false, priority = 1000 },
    { "RRethy/base16-nvim", lazy = false, priority = 1000 },
    { "oskarnurm/koda.nvim", lazy = false, priority = 1000 },
    { "casedami/neomodern.nvim", lazy = false, priority = 1000 },
})
