return {
    "nvim-java/nvim-java",
    dependencies = {
        "nvim-java/lua-async-await",
        "nvim-java/nvim-java-refactor",
        "nvim-java/nvim-java-core",
        "nvim-java/nvim-java-test",
        "MunifTanjim/nui.nvim",
        "neovim/nvim-lspconfig",
        {
            "williamboman/mason.nvim",
            opts = {
                registries = {
                    "github:nvim-java/mason-registry",
                    "github:mason-org/mason-registry",
                },
            },
        },
    },
    ft = { "java" },
    config = function()
        require("java").setup({
            java_test = {
                enable = true,
            },
            spring_boot_tools = {
                enable = true,
            },
            jdk = {
                auto_install = true,
            },
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                local opts = { buffer = true, silent = true }

                vim.keymap.set("n", "<leader>jo", function()
                    require("jdtls").organize_imports()
                end, vim.tbl_extend("force", opts, { desc = "Organize Imports" }))

                vim.keymap.set("n", "<leader>jv", function()
                    require("jdtls").extract_variable()
                end, vim.tbl_extend("force", opts, { desc = "Extract Variable" }))

                vim.keymap.set("v", "<leader>jv", function()
                    require("jdtls").extract_variable(true)
                end, vim.tbl_extend("force", opts, { desc = "Extract Variable" }))

                vim.keymap.set("n", "<leader>jc", function()
                    require("jdtls").extract_constant()
                end, vim.tbl_extend("force", opts, { desc = "Extract Constant" }))

                vim.keymap.set("v", "<leader>jc", function()
                    require("jdtls").extract_constant(true)
                end, vim.tbl_extend("force", opts, { desc = "Extract Constant" }))

                vim.keymap.set("v", "<leader>jm", function()
                    require("jdtls").extract_method(true)
                end, vim.tbl_extend("force", opts, { desc = "Extract Method" }))

                vim.keymap.set("n", "<leader>jtc", function()
                    require("jdtls").test_class()
                end, vim.tbl_extend("force", opts, { desc = "Test Class" }))

                vim.keymap.set("n", "<leader>jtm", function()
                    require("jdtls").test_nearest_method()
                end, vim.tbl_extend("force", opts, { desc = "Test Method" }))
            end,
        })
    end,

    keys = {
        { "<leader>jr", ":RunCode<CR>", desc = "Java Run Options", ft = "java", mode = "n", silent = true },
    },
}
