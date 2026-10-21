-- Neogit is a Magit-style git interface, including commit.
-- https://github.com/NeogitOrg/neogit
--
-- Inside the status buffer, `c` opens the commit popup and `c` again writes the commit.
-- In the commit message buffer, `<C-c><C-c>` submits and `<C-c><C-k>` aborts.

vim.pack.add { 'https://github.com/NeogitOrg/neogit' }

local neogit = require 'neogit'

neogit.setup {
  integrations = {
    -- Telescope is already installed and is used for branch, commit, and remote menus.
    telescope = true,
  },
}

require('which-key').add {
  { '<leader>g', group = '[G]it' },
}

vim.keymap.set('n', '<leader>gg', neogit.open, { desc = '[G]it status' })
vim.keymap.set('n', '<leader>gc', function() neogit.open { 'commit' } end, { desc = '[G]it [c]ommit' })
