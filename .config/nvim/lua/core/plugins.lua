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
    {
        "folke/which-key.nvim",
        dependencies = { "echasnovski/mini.icons", version = false },
        opts = {
            preset = "classic",
            filter = function(mapping)
                return mapping.desc and mapping.desc ~= ""
            end,
        },
    },
    {

        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
    },
    {
        "nvim-tree/nvim-web-devicons",
    },
    {
        "lewis6991/gitsigns.nvim",
    },
    {
        "numToStr/Comment.nvim",
    },
    {
        "stevearc/conform.nvim",
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "williamboman/mason.nvim",
    },
    {
        "stevearc/oil.nvim",
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "dgox16/oldworld.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    },
    {
        "RRethy/base16-nvim"
    },
})
