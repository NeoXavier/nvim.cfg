return {
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({})

            vim.keymap.set("n", "<leader>q", function()
                require("trouble").toggle()
            end)

            -- Navigation
            vim.keymap.set("n", "]d", function()
                require("trouble").next({skip_groups = true, jump = true});
            end)

            vim.keymap.set("n", "[d", function()
                require("trouble").previous({skip_groups = true, jump = true});
            end)

        end
    },
}

