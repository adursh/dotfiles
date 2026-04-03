return {
	"akinsho/bufferline.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	priority = 900,
	config = function()
		require("bufferline").setup({
			options = {
				always_show_bufferline = false,
			},
		})
		local opts = { noremap = true, silent = true }
		-- vim.keymap.set("n", "<M-{>", ":bnext<CR>", opts)
		-- vim.keymap.set("n", "<M-}>", ":bprevious<CR>", opts)
		-- vim.keymap.set("n", "<S-j>", ":bnext<CR>", opts)
		-- vim.keymap.set("n", "<M-S-]>", ":bprevious<CR>", opts)
		vim.keymap.set("n", "<S-k>", ":bnext<CR>", opts)
		vim.keymap.set("n", "<S-j>", ":bprevious<CR>", opts)
		vim.keymap.set("n", "<leader>w", ":bdelete<CR>", opts)
		vim.keymap.set("n", "<leader>W", ":bdelete<CR>", opts)
	end,
}
