require("set")
require("remap")

local augroup = vim.api.nvim_create_augroup
local XavierGroup = augroup('Xavier', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

if vim.g.vscode then
    -- VSCode
    require("remap_vscode")
else
    -- Normal Neovim
    require("remap_nvim")
    require("config.lazy_init")
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
    function R(name)
        require("plenary.reload").reload_module(name)
    end

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
            vim.keymap.set("n", "dq", vim.diagnostic.setqflist, opts)
            --vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
            --vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
            --vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        end
    })
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

vim.g.python3_host_prog = '/Users/xavier/.pyenv/versions/3.11.0/envs/nvim/bin/python'

local function set_normal_float_highlight()
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#282828" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = set_normal_float_highlight,
})
