-- Description: Remap keys for vanilla neovim

-- Jump buffers
vim.keymap.set("n", "<leader><Tab>", "<cmd>bn<CR>")
vim.keymap.set("n", "<leader><S-Tab>", "<cmd>bp<CR>")
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>")

-- Split windows
vim.keymap.set("n", "<C-w><Bar>", ":vsplit<CR>")
vim.keymap.set("n", "<C-w>_", ":split<CR>")

--Fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- Undo tree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Symbols Outline
vim.keymap.set("n", "<leader>so", vim.cmd.SymbolsOutline)
