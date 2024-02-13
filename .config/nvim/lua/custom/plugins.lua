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
		'nvim-telescope/telescope.nvim',
		tag = '0.1.1',
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
	},
	{
		'nvim-telescope/telescope-media-files.nvim',
		'nvim-lua/popup.nvim'
	},
	{
		"nvim-treesitter/nvim-treesitter", run = ":TSUpdate",
	},
	{
		"folke/which-key.nvim",
	},
	{
		"nvim-tree/nvim-web-devicons"
	},
	{
		-- "nvim-tree/nvim-tree.lua"
	},
	{
		"numToStr/Comment.nvim"
	},
	{
		-- "lukas-reineke/indent-blankline.nvim"
	},
	{
		"EdenEast/nightfox.nvim"
	},
	{
		-- "williamboman/mason.nvim",
		-- "williamboman/mason-lspconfig.nvim",
		-- "neovim/nvim-lspconfig",
	},
	{
		-- "hrsh7th/cmp-nvim-lsp",
		-- "hrsh7th/cmp-buffer",
		-- "hrsh7th/cmp-path",
		-- "hrsh7th/cmp-cmdline",
		-- "hrsh7th/nvim-cmp",
		-- "L3MON4D3/LuaSnip",
		-- "saadparwaiz1/cmp_luasnip",
	},
	{
		"luukvbaal/statuscol.nvim",
		"TimUntersberger/neogit",
		"lewis6991/gitsigns.nvim",
	},
	{
		-- "mfussenegger/nvim-dap",
		-- "rcarriga/nvim-dap-ui"
	},
	{
		-- "nvim-lualine/lualine.nvim",
		-- "rebelot/heirline.nvim",
	},
        {
            "shortcuts/no-neck-pain.nvim"
        },
})
