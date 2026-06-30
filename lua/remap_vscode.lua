-- Formatting
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("v", "<leader>f", vim.lsp.buf.format)

-- Open netrw
vim.keymap.set("n", "<leader>o", vim.cmd.Ex)

-- VSCode commands
local function vscode(cmd)
    return function() return require("vscode").call(cmd) end
end

-- Find-it-Faster (telescope alternative)
vim.keymap.set('n', '<leader>ff', vscode('find-it-faster.findFiles'), { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>lg', vscode('find-it-faster.findWithinFiles'), {  desc = '[L]ive [G]rep' })

-- Jump buffers
vim.keymap.set("n", "<leader><Tab>", vscode("workbench.action.nextEditor"))
vim.keymap.set("n", "<leader><S-Tab>", vscode("workbench.action.previousEditor"))
vim.keymap.set("n", "<leader>bd", vscode("workbench.action.closeActiveEditor"))

-- Move between windows (inbuilt into nvim)
vim.keymap.set("n", "<C-w>h", vscode('workbench.action.navigateLeft'))
vim.keymap.set("n", "<C-w>l", vscode('workbench.action.navigateRight'))
vim.keymap.set("n", "<C-w>j", vscode('workbench.action.navigateDown'))
vim.keymap.set("n", "<C-w>k", vscode('workbench.action.navigateUp'))

-- Split windows
vim.keymap.set("n", "<C-w><Bar>", vscode('workbench.action.splitEditor'))
vim.keymap.set("n", "<C-w>_", vscode('workbench.action.splitEditorOrthogonal'))

-- Zen mode
vim.keymap.set("n", "<leader>zz", vscode('workbench.action.toggleZenMode'))
