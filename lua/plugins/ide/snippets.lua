return {
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",

        dependencies = { "rafamadriz/friendly-snippets" },

        config = function()
            local ls = require("luasnip")
            ls.filetype_extend("javascript", { "jsdoc" })

            --- Keymaps
            vim.keymap.set({ "i", "s" }, "<M-l>", function() ls.jump(1) end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<M-h>", function() ls.jump(-1) end, { silent = true })


            vim.keymap.set({ "i", "s" }, "<M-j>", function()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end, { silent = true })

            vim.keymap.set({ "i", "s" }, "<M-k>", function()
                if ls.choice_active() then
                    ls.change_choice(-1)
                end
            end, { silent = true })
            ls.config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
                enable_autosnippets = true,
                ext_opts = {
                    [require("luasnip.util.types").choiceNode] = {
                        active = {
                            virt_text = { { "●", "Comment" } },
                        },
                    },
                },
            })

            local snippets_paths = function()
                local paths = {}
                local root_path = vim.env.HOME
                local custom = "/.config/nvim/mySnippets"
                local user_path

                user_path = root_path .. custom
                if vim.fn.isdirectory(user_path) ~= 0 then
                    table.insert(paths, user_path)
                end

                return paths
            end

            local list_snips = function()
                local ft_list = require("luasnip").available()[vim.o.filetype]
                local ft_snips = {}
                for _, item in pairs(ft_list) do
                    ft_snips[item.trigger] = item.name
                end
                print(vim.inspect(ft_snips))
            end

            vim.api.nvim_create_user_command("SnipList", list_snips, {})

            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = "~/.config/nvim/mySnippets",
                --include = nil, -- Load all languages
                exclude = { "plaintex", "tex" },
            })
        end,
    }
}
