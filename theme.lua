return {
	{ "EdenEast/nightfox.nvim", lazy = true },
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{ "rebelot/kanagawa.nvim", lazy = true },
	{ "gthelding/monokai-pro.nvim", lazy = true },
	{ "rose-pine/neovim", lazy = true },
	{ "catppuccin/nvim", lazy = true },
	{ "neanias/everforest-nvim", lazy = true },
	{ "ribru17/bamboo.nvim", lazy = true },
	{ "tahayvr/matteblack.nvim", lazy = true },
	{ "folke/tokyonight.nvim", lazy = true },
	{ "kepano/flexoki-neovim", lazy = true },

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
