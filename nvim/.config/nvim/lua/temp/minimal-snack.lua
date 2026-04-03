return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- Keep all the useful utilities
        bigfile = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 3000,
        },
        words = { enabled = true },
        scratch = { enabled = true },
        rename = { enabled = true },
        bufdelete = { enabled = true },
        zen = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },

        -- Disable components we're replacing
        dashboard = { enabled = false },
        explorer = { enabled = false },
        picker = { enabled = false },
        quickfile = { enabled = false },

        -- Restore transparency styles
        styles = {
            notification = {
                wo = { wrap = true, winblend = 0 },
                bo = {},
            },
            input = {
                wo = { winblend = 0 },
                backdrop = false,
            },
            scratch = {
                wo = { winblend = 0 },
                backdrop = false,
            },
        },
        win = {
            enabled = true,
            wo = {
                winblend = 0,
            },
        },
    },
    keys = {
        -- Utility keymaps
        {
            "<leader>.",
            function()
                Snacks.scratch()
            end,
            desc = "Toggle Scratch Buffer",
        },
        {
            "<leader>S",
            function()
                Snacks.scratch.select()
            end,
            desc = "Select Scratch Buffer",
        },
        {
            "<leader>bd",
            function()
                Snacks.bufdelete()
            end,
            desc = "Delete Buffer",
        },
        {
            "<leader>cR",
            function()
                Snacks.rename.rename_file()
            end,
            desc = "Rename File",
        },
        {
            "<leader>z",
            function()
                Snacks.zen()
            end,
            desc = "Toggle Zen Mode",
        },
        {
            "<leader>Z",
            function()
                Snacks.zen.zoom()
            end,
            desc = "Toggle Zoom",
        },
        {
            "<leader>un",
            function()
                Snacks.notifier.hide()
            end,
            desc = "Dismiss All Notifications",
        },
        -- Fixed notification history
        {
            "<leader>n",
            function()
                -- Use nvim-notify history instead
                require("telescope").extensions.notify.notify()
            end,
            desc = "Notification History",
        },
        {
            "<leader>N",
            function()
                Snacks.win({
                    file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
                    width = 0.6,
                    height = 0.6,
                    wo = {
                        spell = false,
                        wrap = false,
                        signcolumn = "yes",
                        statuscolumn = " ",
                        conceallevel = 3,
                        winblend = 0,
                    },
                })
            end,
            desc = "Neovim News",
        },
        -- Word navigation
        {
            "]]",
            function()
                Snacks.words.jump(vim.v.count1)
            end,
            desc = "Next Reference",
            mode = { "n", "t" },
        },
        {
            "[[",
            function()
                Snacks.words.jump(-vim.v.count1)
            end,
            desc = "Prev Reference",
            mode = { "n", "t" },
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup debugging globals
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd

                -- All toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.line_number():map("<leader>ul")
                Snacks.toggle
                    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                    :map("<leader>uc")
                Snacks.toggle.treesitter():map("<leader>uT")
                Snacks.toggle
                    .option("background", { off = "light", on = "dark", name = "Dark Background" })
                    :map("<leader>ub")
                Snacks.toggle.inlay_hints():map("<leader>uh")
                Snacks.toggle.indent():map("<leader>ug")
                Snacks.toggle.dim():map("<leader>uD")
            end,
        })

        -- Transparency setup
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = function()
                vim.cmd([[
                    highlight Normal guibg=NONE ctermbg=NONE
                    highlight NormalFloat guibg=NONE ctermbg=NONE
                    highlight NormalNC guibg=NONE ctermbg=NONE
                    highlight EndOfBuffer guibg=NONE ctermbg=NONE
                    highlight SignColumn guibg=NONE ctermbg=NONE
                    highlight VertSplit guibg=NONE ctermbg=NONE
                    highlight StatusLine guibg=NONE ctermbg=NONE
                    highlight StatusLineNC guibg=NONE ctermbg=NONE
                    highlight FloatBorder guibg=NONE ctermbg=NONE
                    highlight Pmenu guibg=NONE ctermbg=NONE
                    highlight PmenuSel guibg=NONE ctermbg=NONE
                    highlight WinSeparator guibg=NONE ctermbg=NONE
                ]])
            end,
        })

        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                vim.cmd([[
                    highlight Normal guibg=NONE ctermbg=NONE
                    highlight NormalFloat guibg=NONE ctermbg=NONE
                    highlight FloatBorder guibg=NONE ctermbg=NONE
                    highlight Pmenu guibg=NONE ctermbg=NONE
                    highlight WinSeparator guibg=NONE ctermbg=NONE
                ]])
            end,
        })
    end,
}
