return {
    {
        "romus204/tree-sitter-manager.nvim",
        dependencies = {}, -- tree-sitter CLI must be installed system-wide
        config = function()
            require("tree-sitter-manager").setup(
                {
                    ensure_installed = { 'vimdoc', 'javascript', 'typescript', 'c', 'lua', 'rust', 'jsdoc', 'bash' },
                    auto_install=true,
                }
            )
        end,
    }
}
