-- plugins/git-integration.lua
-- Git-related plugins
return {
	-- GitSigns for git decorations
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
			current_line_blame = false,
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

				-- Navigation
				map("n", "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, "Next Hunk")
				map("n", "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, "Prev Hunk")
				map("n", "]H", function()
					gs.nav_hunk("last")
				end, "Last Hunk")
				map("n", "[H", function()
					gs.nav_hunk("first")
				end, "First Hunk")

				-- Actions
				map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
				map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
				map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
				map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
				map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
				map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
				map("n", "<leader>ghb", function()
					gs.blame_line({ full = true })
				end, "Blame Line")
				map("n", "<leader>ghtb", gs.toggle_current_line_blame, "Toggle Git Blame Line")
				map("n", "<leader>ghd", gs.diffthis, "Diff This")
				map("n", "<leader>ghD", function()
					gs.diffthis("~")
				end, "Diff This ~")

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},

	-- LazyGit integration
	{
		"kdheepak/lazygit.nvim",
		cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "Lazygit" },
			{ "<leader>gL", "<cmd>LazyGit<cr>", desc = "Lazygit Log" },
		},
		config = function()
			vim.g.lazygit_floating_window_winblend = 0
			vim.g.lazygit_floating_window_scaling_factor = 0.9
			vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
			vim.g.lazygit_floating_window_use_plenary = 0
			vim.g.lazygit_use_neovim_remote = 1
		end,
	},

	-- Git browse in browser
	{
		"ruanyl/vim-gh-line",
		keys = {
			{
				"<leader>gB",
				":GHInteractive<CR>",
				desc = "Git Browse",
				mode = { "n", "v" },
			},
		},
	},
}
