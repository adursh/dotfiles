return {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {},
    config = function()
        require("toggleterm").setup({
            open_mapping = [[<C-/>]],
            direction = "float",
            hide_numbers = true,
            shade_filetypes = {},
            autochdir = true,

            shade_terminals = true, -- NOTE: takes priority over highlights, so set false if you customize highlights
            shading_factor = 2, -- % to lighten dark terminal bg (default: -30)
            -- shading_ratio  = 1, -- ratio of shading factor for light/dark terminal bg (default: -3)

            start_in_insert = true,
            insert_mappings = true,  -- whether open_mapping applies in insert mode
            terminal_mappings = true, -- whether mappings apply inside terminals
            persist_size = true,
            persist_mode = false,     -- remember previous terminal mode
            close_on_exit = true,     -- close terminal when process exits
            clear_env = false,        -- use only env vars passed in `env`
            shell = vim.o.shell,      -- default shell
            auto_scroll = true,       -- auto scroll to bottom on output

            -- Only relevant if direction = 'float'
            float_opts = {
                border = "curved",
                background = "normal",
                -- border = 'single' | 'double' | 'shadow' | 'curved' | ... (see :h nvim_open_win)
                -- width  = <value>,
                -- height = <value>,
                -- row    = <value>,
                -- col    = <value>,
                winblend = 0,
                -- zindex  = <value>,
                title_pos = "center", -- 'left' | 'center' | 'right'
            },

            winbar = {
                enabled = false,
                name_formatter = function(term) -- term: Terminal
                    return term.name
                end,
            },

            responsiveness = {
                -- breakpoint (in vim.o.columns) at which horizontal terminals stack vertically
                -- default = 0 (disabled)
                horizontal_breakpoint = 135,
            },
        })
    end,
}
