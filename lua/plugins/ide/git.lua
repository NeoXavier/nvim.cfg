return {
    -- {
    --     "tpope/vim-fugitive",
    --     config = function()
    --         vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    --
    --         local Fugitive = vim.api.nvim_create_augroup("Fugitive", {})
    --
    --         local autocmd = vim.api.nvim_create_autocmd
    --         autocmd("BufWinEnter", {
    --             group = Fugitive,
    --             pattern = "*",
    --             callback = function()
    --                 if vim.bo.ft ~= "fugitive" then
    --                     return
    --                 end
    --
    --                 local bufnr = vim.api.nvim_get_current_buf()
    --                 local opts = {buffer = bufnr, remap = false}
    --                 vim.keymap.set("n", "<leader>gp", function()
    --                     vim.cmd.Git('push')
    --                 end, opts)
    --
    --                 -- rebase always
    --                 vim.keymap.set("n", "<leader>gr", function()
    --                     vim.cmd.Git({'pull',  '--rebase'})
    --                 end, opts)
    --
    --                 -- NOTE: It allows me to easily set the branch i am pushing and any tracking
    --                 -- needed if i did not set the branch up correctly
    --                 vim.keymap.set("n", "<leader>gt", ":Git push -u origin ", opts);
    --             end,
    --         })
    --
    --
    --         vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
    --         vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    --     end
    -- },
    "lewis6991/gitsigns.nvim",
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>gs", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    },
    {
        "sindrets/diffview.nvim",
        keys = {
            { "<leader>dv",  "<cmd>DiffviewOpen<cr>", desc = "[D]iff [V]iew Open" },
            { "<leader>dv1",  "<cmd>DiffviewOpen HEAD~1<cr>", desc = "[D]iff [V]iew Open HEAD~[1]" },
            { "<leader>dvc", "<cmd>DiffviewClose<cr>", desc = "[D]iff [V]iew [C]lose" },
        }
    }
}
