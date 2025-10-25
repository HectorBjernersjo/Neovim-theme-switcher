return {
	{ "EdenEast/nightfox.nvim", Lazy = true },
	{ "ellisonleao/gruvbox.nvim", Lazy = true },
	{ "rebelot/kanagawa.nvim", Lazy = true },
	{ "gthelding/monokai-pro.nvim", Lazy = true },
	{ "rose-pine/neovim", Lazy = true },
	{ "catppuccin/nvim", Lazy = true },
	{ "neanias/everforest-nvim", Lazy = true },
	{ "ribru17/bamboo.nvim", Lazy = true },
	{ "tahayvr/matteblack.nvim", Lazy = true },
	{ "folke/tokyonight.nvim", Lazy = true },
	{ "kepano/flexoki-neovim", Lazy = true },

{
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		vim.cmd.colorscheme("tokyonight-night")
	end,
}
}
