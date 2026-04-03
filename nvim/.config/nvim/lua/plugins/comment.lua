-- return {
-- 	"numToStr/Comment.nvim",
-- 	config = function()
-- 		require("Comment").setup({
-- 			-- everything default
-- 		})
-- 	end,
-- }
return {
	"numToStr/Comment.nvim",
	dependencies = { "folke/ts-comments.nvim" },
	opts = {},
}
