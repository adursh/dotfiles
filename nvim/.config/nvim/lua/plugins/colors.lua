return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = true,
			highlight_overrides = {
				mocha = function(C)
					return {
						NormalFloat = { bg = "NONE" },
						FloatBorder = { bg = "NONE" },
						FloatTitle = { bg = "NONE" },
					}
				end,
			},
			integrations = {
				treesitter = false,
				lsp_trouble = false,
				cmp = false,
				gitsigns = false,
				nvimtree = false,
				notify = false,
				mini = false,
				bufferline = false,
				lualine = false,
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
