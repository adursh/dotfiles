-- plugins/notifications.lua
-- Enhanced notification system
return {
	-- Enhanced notifications with history
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
			background_colour = "#000000",
			render = "wrapped-compact",
			stages = "fade_in_slide_out",
		},
		init = function()
			-- When noice is not enabled, install notify on VeryLazy
			if not package.loaded["noice"] then
				vim.notify = require("notify")
			end
		end,
	},

	-- Telescope extension for notification history
	{
		"nvim-telescope/telescope.nvim",
		optional = true,
		dependencies = {
			{
				"rcarriga/nvim-notify",
				config = function()
					require("telescope").load_extension("notify")
				end,
			},
		},
	},
}
