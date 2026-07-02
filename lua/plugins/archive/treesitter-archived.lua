return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'main',
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({})

            local languages = { 'vimdoc', 'javascript', 'typescript', 'c', 'lua', 'rust', 'jsdoc', 'bash', }

            require('nvim-treesitter').install(languages)

            vim.api.nvim_create_autocmd('FileType', {
                pattern = languages,
                callback = function()
                    -- syntax highlighting, provided by Neovim
                    vim.treesitter.start()
                    -- -- folds, provided by Neovim
                    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                    vim.wo.foldmethod = 'expr'
                    vim.wo.foldlevel = 99
                    -- indentation, provided by nvim-treesitter
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })

            require("nvim-treesitter.parsers").templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "master",
                },
            }

            vim.treesitter.language.register("templ", "templ")
        end
    },
}
