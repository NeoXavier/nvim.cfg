return {
    {
        "benlubas/molten-nvim",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        dependencies = { "3rd/image.nvim" },
        build = ":UpdateRemotePlugins",
        init = function()
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20

            -- I find auto open annoying, keep in mind setting this option will require setting
            -- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
            vim.g.molten_auto_open_output = false

            -- optional, I like wrapping. works for virt text and the output window
            vim.g.molten_wrap_output = true

            -- Output as virtual text. Allows outputs to always be shown, works with images, but can
            -- be buggy with longer images
            vim.g.molten_virt_text_output = true

            -- this will make it so the output shows up below the \`\`\` cell delimiter
            vim.g.molten_virt_lines_off_by_1 = true
        end,
        config = function()
            vim.keymap.set("n", "<leader>e", ":MoltenEvaluateOperator<CR>", { desc = "evaluate operator", silent = true })
            vim.keymap.set("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>",
                { desc = "open output window", silent = true })
            vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>", { desc = "re-eval cell", silent = true })
            vim.keymap.set("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>gv",
                { desc = "execute visual selection", silent = true })
            vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>", { desc = "close output window", silent = true })
            vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })

            -- if you work with html outputs:
            vim.keymap.set("n", "<leader>mx", ":MoltenOpenInBrowser<CR>",
                { desc = "open output in browser", silent = true })
        end,
    },
    {
        -- see the image.nvim readme for more information about configuring this plugin
        "3rd/image.nvim",
        opts = {
            backend = "kitty", -- whatever backend you would like to use
            max_width = 100,
            max_height = 12,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true,    -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
            editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
            tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        },
    },
    {
        "GCBallesteros/jupytext.nvim",
        -- Depending on your nvim distro or config you may need to make the loading not lazy
        lazy = false,
        config = function()
            require("jupytext").setup({
                style = "markdown",
                output_extension = "md",
                force_ft = "markdown",
            })
        end
    },
    -- {
    --     "quarto-dev/quarto-nvim",
    --     dependencies = {
    --         "jmbuhr/otter.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --     },
    --     ft = { 'quarto', 'markdown' },
    --     config = function()
    --         local quarto = require("quarto")
    --         quarto.setup({
    --             lspFeatures = {
    --                 -- NOTE: put whatever languages you want here:
    --                 languages = { "r", "python" },
    --                 chunks = "all",
    --                 diagnostics = {
    --                     enabled = true,
    --                     triggers = { "BufWritePost" },
    --                 },
    --                 completion = {
    --                     enabled = true,
    --                 },
    --             },
    --             keymap = {
    --                 -- NOTE: setup your own keymaps:
    --                 hover = "K",
    --                 definition = "gd",
    --                 rename = "<leader>rn",
    --                 references = "gr",
    --                 format = "<leader>f",
    --             },
    --             codeRunner = {
    --                 enabled = true,
    --                 default_method = "molten",
    --             },
    --         })
    --
    --         local runner = require("quarto.runner")
    --         vim.keymap.set("n", "<leader>rc", runner.run_cell, { desc = "run cell", silent = true })
    --         vim.keymap.set("n", "<leader>ra", runner.run_above, { desc = "run cell and above", silent = true })
    --         vim.keymap.set("n", "<leader>rA", runner.run_all, { desc = "run all cells", silent = true })
    --         vim.keymap.set("n", "<leader>rl", runner.run_line, { desc = "run line", silent = true })
    --         vim.keymap.set("v", "<leader>r", runner.run_range, { desc = "run visual range", silent = true })
    --         vim.keymap.set("n", "<leader>RA", function()
    --             runner.run_all(true)
    --         end, { desc = "run all cells of all languages", silent = true })
    --     end
    -- },
    -- {
    --     'jmbuhr/otter.nvim',
    --     dependencies = {
    --         'nvim-treesitter/nvim-treesitter',
    --     },
    --     opts = {},
    --     config = function()
    --         function otter_extensions(arglead, _, _)
    --             local extensions = require 'otter.tools.extensions'
    --             local out = {}
    --             for k, v in pairs(extensions) do
    --                 if arglead == nil then
    --                     table.insert(out, "*.otter." .. v)
    --                 elseif k:find("^" .. arglead) ~= nil then
    --                     table.insert(out, k)
    --                 end
    --             end
    --             return out
    --         end
    --
    --         vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    --             group = vim.api.nvim_create_augroup("lspconfig", { clear = false }),
    --             pattern = otter_extensions(),
    --             callback = function(ev)
    --                 local buf = ev.buf
    --                 local ft = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
    --                 local matching_configs = require('lspconfig.util').get_config_by_ft(ft)
    --                 for _, config in ipairs(matching_configs) do
    --                     print("Activating ", config.name, " LspOtter in buffer ", buf, "...")
    --                     config.launch(buf)
    --                 end
    --             end
    --         })
    --         vim.cmd [[ command! -nargs=* -complete=customlist,v:lua.otter_extensions LspOtter lua require'otter'.activate({<f-args>}) ]]
    --     end
    -- },
}
