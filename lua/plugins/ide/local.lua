-- Local plugins
return {
    'NeoXavier/jot.nvim',
    lazy = false,
    config = function()
        require('jot').setup({
          dir = vim.fn.stdpath('data') .. '/jot',
          keymaps = {
            toggle = '<leader>t',
            pads   = { '<leader>1', '<leader>2', '<leader>3', '<leader>4' },
            -- optional: seed slots without opening the editor
            pads_files = { 'work.md', 'personal.md' },
          },
        })
    end,
}
