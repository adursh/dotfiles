-- plugins/telescope.lua
-- Enhanced Telescope configuration
return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	version = false, -- telescope did only one release, so use HEAD for now
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			enabled = vim.fn.executable("make") == 1,
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		-- Main picker keymaps (matching your original Snacks config)
		{
			"<leader>,",
			"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
			desc = "Switch Buffer",
		},
		{
			"<leader>/",
			function()
				-- Use find_files if rg is not available
				if vim.fn.executable("rg") == 1 then
					require("telescope.builtin").live_grep()
				else
					require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
				end
			end,
			desc = "Grep (Root Dir)",
		},
		{
			"<leader>:",
			"<cmd>Telescope command_history<cr>",
			desc = "Command History",
		},

		-- File operations
		{
			"<leader>fb",
			"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
			desc = "Buffers",
		},
		{
			"<leader>fB",
			"<cmd>Telescope buffers show_all_buffers=true<cr>",
			desc = "Buffers (all)",
		},
		{
			"<leader>fc",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find Config File",
		},
		{
			"<leader>ff",
			"<cmd>Telescope find_files<cr>",
			desc = "Find Files (Root Dir)",
		},
		{
			"<leader>fF",
			function()
				require("telescope.builtin").find_files({ cwd = vim.uv.cwd() })
			end,
			desc = "Find Files (cwd)",
		},
		{
			"<leader>fg",
			"<cmd>Telescope git_files<cr>",
			desc = "Find Files (git-files)",
		},
		{
			"<leader>fr",
			"<cmd>Telescope oldfiles<cr>",
			desc = "Recent Files",
		},
		{
			"<leader>fR",
			function()
				require("telescope.builtin").oldfiles({ cwd = vim.uv.cwd() })
			end,
			desc = "Recent (cwd)",
		},

		-- Git
		{
			"<leader>gb",
			"<cmd>Telescope git_branches<cr>",
			desc = "Git Branches",
		},
		{
			"<leader>gl",
			"<cmd>Telescope git_commits<cr>",
			desc = "Git Log",
		},
		{
			"<leader>gL",
			"<cmd>Telescope git_bcommits<cr>",
			desc = "Git Log (current file)",
		},
		{
			"<leader>gs",
			"<cmd>Telescope git_status<cr>",
			desc = "Git Status",
		},
		{
			"<leader>gS",
			"<cmd>Telescope git_stash<cr>",
			desc = "Git Stash",
		},
		{
			"<leader>gf",
			"<cmd>Telescope git_bcommits<cr>",
			desc = "Git Log File",
		},

		-- Search
		{
			"<leader>sb",
			"<cmd>Telescope current_buffer_fuzzy_find<cr>",
			desc = "Buffer Lines",
		},
		{
			"<leader>sB",
			"<cmd>Telescope live_grep grep_open_files=true<cr>",
			desc = "Grep Open Buffers",
		},
		{
			"<leader>sg",
			function()
				if vim.fn.executable("rg") == 1 then
					require("telescope.builtin").live_grep()
				else
					require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
				end
			end,
			desc = "Grep (Root Dir)",
		},
		{ "<leader>sw", "<cmd>Telescope grep_string word_match=-w<cr>", desc = "Word (Root Dir)" },
		{
			"<leader>sW",
			"<cmd>Telescope grep_string<cr>",
			desc = "Selection (Root Dir)",
			mode = "v",
		},
		{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
		{ "<leader>s/", "<cmd>Telescope search_history<cr>", desc = "Search History" },
		{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
		{ "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
		{ "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
		{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
		{ "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
		{ "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
		{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
		{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
		{ "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
		{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
		{ "<leader>uC", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Colorscheme with preview" },

		-- LSP
		{ "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
		{ "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
		{ "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
		{ "gy", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition" },
		{ "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Goto Symbol" },
		{ "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Goto Symbol (Workspace)" },
	},
	opts = function()
		local actions = require("telescope.actions")

		local function find_command()
			if 1 == vim.fn.executable("rg") then
				return { "rg", "--files", "--color", "never", "-g", "!.git" }
			elseif 1 == vim.fn.executable("fd") then
				return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
			elseif 1 == vim.fn.executable("fdfind") then
				return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
			elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
				return { "find", ".", "-type", "f" }
			elseif 1 == vim.fn.executable("where") then
				return { "where", "/r", ".", "*" }
			end
		end

		return {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				-- open files in the first window that is an actual file.
				-- use the current window if no other window is available.
				get_selection_window = function()
					local wins = vim.api.nvim_list_wins()
					table.insert(wins, 1, vim.api.nvim_get_current_win())
					for _, win in ipairs(wins) do
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].buftype == "" then
							return win
						end
					end
					return 0
				end,
				mappings = {
					i = {
						["<C-Down>"] = actions.cycle_history_next,
						["<C-Up>"] = actions.cycle_history_prev,
						["<C-f>"] = actions.preview_scrolling_down,
						["<C-b>"] = actions.preview_scrolling_up,
					},
					n = {
						["q"] = actions.close,
					},
				},
			},
			pickers = {
				find_files = {
					find_command = find_command,
					hidden = true,
				},
				buffers = {
					theme = "dropdown",
					previewer = false,
					initial_mode = "normal",
					mappings = {
						i = {
							["<C-d>"] = actions.delete_buffer,
						},
						n = {
							["dd"] = actions.delete_buffer,
						},
					},
				},
				colorscheme = {
					enable_preview = true,
				},
				lsp_references = {
					trim_text = true,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		}
	end,
	config = function(_, opts)
		require("telescope").setup(opts)
		require("telescope").load_extension("ui-select")

		-- Load other extensions if available
		local extensions = {
			"fzf",
			"notify",
			"projects",
		}

		for _, ext in ipairs(extensions) do
			pcall(require("telescope").load_extension, ext)
		end
	end,
}
