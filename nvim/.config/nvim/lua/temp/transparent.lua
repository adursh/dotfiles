return {
	"xiyaowong/transparent.nvim",
	lazy = false, -- Don't lazy load this
	config = function()
		require("transparent").setup({
			extra_groups = {
				"NormalFloat",
				"FloatBorder",
			},
		})
	end,
}
