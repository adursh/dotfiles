-- return {
-- 	{
-- 		"williamboman/mason.nvim",
-- 		lazy = false,
-- 		build = ":MasonUpdate",
-- 		config = function()
-- 			require("mason").setup()
-- 		end,
-- 	},
--
-- 	{
-- 		"williamboman/mason-lspconfig.nvim",
-- 		lazy = false,
-- 		opts = {
-- 			ensure_installed = { "clangd", "lua_ls", "jdtls", "html", "tailwindcss", "cssls", "jsonls" },
-- 			auto_install = true,
-- 		},
-- 	},
--
-- 	{
-- 		"neovim/nvim-lspconfig",
-- 		lazy = false,
-- 		config = function()
-- 			local capabilities = require("cmp_nvim_lsp").default_capabilities()
--
-- 			local lspconfig = require("lspconfig")
--
-- 			lspconfig.lua_ls.setup({ capabilities = capabilities })
-- 			lspconfig.ts_ls.setup({ capabilities = capabilities })
-- 			lspconfig.clangd.setup({ capabilities = capabilities })
-- 			lspconfig.jdtls.setup({ capabilities = capabilities })
-- 			--			lspconfig.pyright.setup({ capabilities = capabilities })
-- 			--			lspconfig.rust_analyzer.setup({ capabilities = capabilities })
-- 			lspconfig.html.setup({ capabilities = capabilities })
-- 			lspconfig.cssls.setup({ capabilities = capabilities })
-- 			lspconfig.tailwindcss.setup({ capabilities = capabilities })
-- 			lspconfig.jsonls.setup({ capabilities = capabilities })
--
-- 			-- vim.keymap.set("n", "gh", vim.lsp.buf.hover, {})
-- 			-- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
-- 			-- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
-- 			-- vim.keymap.set("n", "gca", vim.lsp.buf.code_action, {})
-- 		end,
-- 	},
-- }



return {
    -- Mason for managing LSPs, linters, and formatters
    {
        "williamboman/mason.nvim",
        lazy = false,
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },

    -- Mason LSP config for auto-installing language servers
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            -- ensure_installed = { "clangd", "lua_ls", "jdtls", "html", "tailwindcss", "cssls", "jsonls" },
            auto_install = true,
        },
    },

    -- nvim-lspconfig to configure installed LSP servers
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require("lspconfig")

            -- Setup LSPs with capabilities
            lspconfig.lua_ls.setup({ capabilities = capabilities })
            lspconfig.ts_ls.setup({ capabilities = capabilities })
            lspconfig.clangd.setup({ capabilities = capabilities })
            lspconfig.jdtls.setup({ capabilities = capabilities })
            -- lspconfig.pyright.setup({ capabilities = capabilities })
            -- lspconfig.rust_analyzer.setup({ capabilities = capabilities })
            lspconfig.html.setup({ capabilities = capabilities })
            lspconfig.cssls.setup({ capabilities = capabilities })
            lspconfig.tailwindcss.setup({ capabilities = capabilities })
            lspconfig.jsonls.setup({ capabilities = capabilities })

            -- Keymaps for LSP actions (hover, go to definition, references, etc.)
            -- vim.keymap.set("n", "gh", vim.lsp.buf.hover, {})
            -- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            -- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            -- vim.keymap.set("n", "gca", vim.lsp.buf.code_action, {})
        end,
    },

    -- Mason-null-ls for managing formatters and linters (auto-install)
    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = {
                    -- Formatters
                    "stylua", "black", "isort", "clang-format", "google_java_format", "prettierd", "stylelint",
                    -- Linters
                    "cppcheck", "eslint_d", "luacheck", "flake8", "rustfmt", "clippy"
                },
                automatic_installation = true,
            })
        end,
    },
}

