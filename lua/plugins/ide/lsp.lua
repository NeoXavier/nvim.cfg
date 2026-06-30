-- local lspkind = require("lspkind")
-- local source_mapping = {
--     buffer = "[Buffer]",
--     nvim_lsp = "[LSP]",
--     nvim_lua = "[Lua]",
--     path = "[Path]",
-- }
--
-- local opts = {
--     -- whether to highlight the currently hovered symbol
--     -- disable if your cpu usage is higher than you want it
--     -- or you just hate the highlight
--     -- default: true
--     highlight_hovered_item = true,
--     -- whether to show outline guides
--     -- default: true
--     show_guides = true,
-- }
--
-- require("symbols-outline").setup(opts)

return {
    {

        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
        },

        config = function()
            local cmp = require('cmp')
            local cmp_lsp = require('cmp_nvim_lsp')
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities()
            )

            require('fidget').setup({})
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'html',
                    'cssls',
                    'pyright'
                },

                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,
                    ["lua_ls"] = function()
                        local lspconfig = require('lspconfig')
                        lspconfig.lua_ls.setup {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { 'vim' }
                                    }
                                }
                            }

                        }
                    end,
                }
            })

            local cmp_select = { behavior = cmp.SelectBehavior.Insert }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<Tab>'] = nil,
                    ['<S-Tab>'] = nil,
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                        { name = "buffer" },
                    })
            })

            vim.diagnostic.config({
                -- virtual_text = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end
    },
    "onsails/lspkind-nvim",
}
