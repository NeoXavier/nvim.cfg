require("set")
require("remap")
require("config.lazy_init")

if vim.g.vscode then
    -- VSCode
    require("remap_vscode")
else
    -- Normal Neovim
    require("remap_nvim")
end


require("lazy").setup({
    spec = {
        {
            import = "plugins.shared"
        },
        {
            import = "plugins.ide",
            cond = function()
                return not vim.g.vscode
            end
        }
    },
    change_detection = { notify = false }
})


local augroup = vim.api.nvim_create_augroup
local XavierGroup = augroup('Xavier', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = XavierGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = XavierGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        --vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        --vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        --vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.g.python3_host_prog = '/Users/xavier/.pyenv/versions/3.11.0/envs/nvim/bin/python'
