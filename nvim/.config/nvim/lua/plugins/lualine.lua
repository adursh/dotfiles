return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "auto",
				icons_enabled = true,
				component_separators = { left = "\u{e0b1}", right = "\u{e0b3}" },
				section_separators = { left = "\u{e0b0}", right = "\u{e0b2}" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					{
						"filetype",
						icon_only = true,
						separator = "",
						padding = { left = 1, right = 0 },
					},
					{
						"filename",
						padding = { left = 0, right = 1 },
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{
						"location",

						-- colors
						color = { fg = "grey", bg = "NONE", gui = "italic"}, -- gui: bold, italic, underline

						-- separators (override just this component's separators)
						separator = { left = "", right = "" }, -- set to "" to remove

						-- spacing
						padding = { left = 1, right = 1 },

						-- icon before the component text
						icon = "",

						-- transform the displayed text
						fmt = function(str)
							return str
						end,

						-- hide component when this returns false
						cond = function()
							return true
						end,
					},
				},
			},
		})
	end,
}
