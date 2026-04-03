return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
	config = function()
		-- Install formatters/linters via Mason
		require("mason-null-ls").setup({
			ensure_installed = {
				"stylua",
				"black",
				"isort",
				"prettierd",
				"clang-format",
			},
			automatic_installation = true,
		})

		-- Configure none-ls
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.prettierd,
				null_ls.builtins.formatting.clang_format,
			},
		})

		-- Format on save (optional, uncomment if you want it)
		-- vim.api.nvim_create_autocmd("BufWritePre", {
		-- 	callback = function()
		-- 		vim.lsp.buf.format({ async = false })
		-- 	end,
		-- })

		-- Manual format keymap
		vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, {})
	end,
}
