-- -- return {
-- -- 	{
-- -- 		"williamboman/mason.nvim",
-- -- 		lazy = false,
-- -- 		build = ":MasonUpdate",
-- -- 		config = function()
-- -- 			require("mason").setup()
-- -- 		end,
-- -- 	},
-- --
-- -- 	{
-- -- 		"williamboman/mason-lspconfig.nvim",
-- -- 		lazy = false,
-- -- 		opts = {
-- -- 			ensure_installed = { "clangd", "lua_ls", "jdtls", "html", "tailwindcss", "cssls", "jsonls" },
-- -- 			auto_install = true,
-- -- 		},
-- -- 	},
-- --
-- -- 	{
-- -- 		"neovim/nvim-lspconfig",
-- -- 		lazy = false,
-- -- 		config = function()
-- -- 			local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- --
-- -- 			local lspconfig = require("lspconfig")
-- --
-- -- 			lspconfig.lua_ls.setup({ capabilities = capabilities })
-- -- 			lspconfig.ts_ls.setup({ capabilities = capabilities })
-- -- 			lspconfig.clangd.setup({ capabilities = capabilities })
-- -- 			lspconfig.jdtls.setup({ capabilities = capabilities })
-- -- 			--			lspconfig.pyright.setup({ capabilities = capabilities })
-- -- 			--			lspconfig.rust_analyzer.setup({ capabilities = capabilities })
-- -- 			lspconfig.html.setup({ capabilities = capabilities })
-- -- 			lspconfig.cssls.setup({ capabilities = capabilities })
-- -- 			lspconfig.tailwindcss.setup({ capabilities = capabilities })
-- -- 			lspconfig.jsonls.setup({ capabilities = capabilities })
-- --
-- -- 			-- vim.keymap.set("n", "gh", vim.lsp.buf.hover, {})
-- -- 			-- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
-- -- 			-- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
-- -- 			-- vim.keymap.set("n", "gca", vim.lsp.buf.code_action, {})
-- -- 		end,
-- -- 	},
-- -- }
--
--
--
-- return {
--     -- Mason for managing LSPs, linters, and formatters
--     {
--         "williamboman/mason.nvim",
--         lazy = false,
--         build = ":MasonUpdate",
--         config = function()
--             require("mason").setup()
--         end,
--     },
--
--     -- Mason LSP config for auto-installing language servers
--     {
--         "williamboman/mason-lspconfig.nvim",
--         lazy = false,
--         opts = {
--             -- ensure_installed = { "clangd", "lua_ls", "jdtls", "html", "tailwindcss", "cssls", "jsonls" },
--             auto_install = false,
--         },
--     },
--
--     -- nvim-lspconfig to configure installed LSP servers
--     {
--         "neovim/nvim-lspconfig",
--         lazy = false,
--         config = function()
--             local capabilities = require("cmp_nvim_lsp").default_capabilities()
--
--             local lspconfig = require("lspconfig")
--
--             -- Setup LSPs with capabilities
--             lspconfig.lua_ls.setup({ capabilities = capabilities })
--             lspconfig.ts_ls.setup({ capabilities = capabilities })
--             lspconfig.clangd.setup({ capabilities = capabilities })
--             lspconfig.jdtls.setup({ capabilities = capabilities })
--             -- lspconfig.pyright.setup({ capabilities = capabilities })
--             -- lspconfig.rust_analyzer.setup({ capabilities = capabilities })
--             lspconfig.html.setup({ capabilities = capabilities })
--             lspconfig.cssls.setup({ capabilities = capabilities })
--             lspconfig.tailwindcss.setup({ capabilities = capabilities })
--             lspconfig.jsonls.setup({ capabilities = capabilities })
--
--             -- Keymaps for LSP actions (hover, go to definition, references, etc.)
--             -- vim.keymap.set("n", "gh", vim.lsp.buf.hover, {})
--             -- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
--             -- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
--             -- vim.keymap.set("n", "gca", vim.lsp.buf.code_action, {})
--         end,
--     },
--
--     -- Mason-null-ls for managing formatters and linters (auto-install)
--     {
--         "jay-babu/mason-null-ls.nvim",
--         dependencies = {
--             "williamboman/mason.nvim",
--             "nvimtools/none-ls.nvim",
--         },
--         config = function()
--             require("mason-null-ls").setup({
--                 -- ensure_installed = {
--                 --     -- Formatters
--                 --     "stylua", "black", "isort", "clang-format", "google_java_format", "prettierd", "stylelint",
--                 --     -- Linters
--                 --     "cppcheck", "eslint_d", "luacheck", "flake8", "rustfmt", "clippy"
--                 -- },
--                 automatic_installation = false,
--             })
--         end,
--     },
-- }
--
--

return {
	-- 1. Mason (package manager for LSPs, formatters, linters)
	{
		"williamboman/mason.nvim",
		lazy = false,
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},

	-- 2. Mason-LSPConfig (auto-installs LSP servers)
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",      -- C/C++
					"lua_ls",      -- Lua
					"jdtls",       -- Java
					"html",        -- HTML
					"tailwindcss", -- Tailwind CSS
					"cssls",       -- CSS
					"jsonls",      -- JSON
				},
				automatic_installation = true,
			})
		end,
	},

	-- 3. nvim-lspconfig (configures the LSP servers)
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Safely check if cmp_nvim_lsp is available
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			
			if has_cmp then
				capabilities = cmp_nvim_lsp.default_capabilities()
			end

			-- Safely check if lspconfig is available
			local has_lspconfig, lspconfig = pcall(require, "lspconfig")
			if not has_lspconfig then
				vim.notify("lspconfig not found", vim.log.levels.ERROR)
				return
			end

			-- List of servers to setup
			local servers = {
				"lua_ls",
				"clangd",
				"jdtls",
				"html",
				"cssls",
				"tailwindcss",
				"jsonls",
			}

			-- Setup each server with error handling
			for _, server in ipairs(servers) do
				-- Check if server config exists
				if lspconfig[server] then
					local ok, err = pcall(function()
						lspconfig[server].setup({
							capabilities = capabilities,
						})
					end)
					if not ok then
						vim.notify("Failed to setup " .. server .. ": " .. tostring(err), vim.log.levels.WARN)
					end
				else
					vim.notify("LSP config not found for: " .. server, vim.log.levels.WARN)
				end
			end

			-- Keymaps for LSP features (uncomment to use)
			-- vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })
			-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
			-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
			-- vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
			-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
			-- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
			-- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
			-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
			-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
		end,
	},

	-- 4. Completion plugins
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
	},
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },

	-- 5. None-LS (null-ls) for formatters and linters
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local has_null_ls, null_ls = pcall(require, "null-ls")
			if not has_null_ls then
				return
			end

			null_ls.setup({
				sources = {
					-- Lua
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.diagnostics.luacheck,

					-- C/C++
					null_ls.builtins.formatting.clang_format,
					null_ls.builtins.diagnostics.cppcheck,

					-- Java
					null_ls.builtins.formatting.google_java_format,

					-- Python
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.isort,
					null_ls.builtins.diagnostics.flake8,

					-- JavaScript/TypeScript/Web
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.diagnostics.eslint_d,

					-- CSS
					null_ls.builtins.diagnostics.stylelint,
				},
			})
		end,
	},

	-- 6. Mason-Null-LS (auto-installs formatters and linters)
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			local has_mason_null_ls, mason_null_ls = pcall(require, "mason-null-ls")
			if not has_mason_null_ls then
				return
			end

			mason_null_ls.setup({
				ensure_installed = {
					-- Formatters
					"stylua",             -- Lua
					"clang-format",       -- C/C++
					"google-java-format", -- Java (note the hyphen!)
					"black",              -- Python
					"isort",              -- Python imports
					"prettierd",          -- JS/TS/HTML/CSS/JSON
					
					-- Linters
					"luacheck",           -- Lua
					"cppcheck",           -- C/C++
					"eslint_d",           -- JavaScript/TypeScript
					"flake8",             -- Python
					"stylelint",          -- CSS
				},
				automatic_installation = true,
			})
		end,
	},
}
