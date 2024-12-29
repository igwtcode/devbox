-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Open Oil (file explorer)
vim.keymap.set('n', '<leader>e', '<cmd>Oil --float<CR>', { desc = 'Explorer' })

-- zen mode
vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<CR>', { desc = 'Toggle [Z]en mode' })

-- vim.keymap.set('n', '<leader>r', '<cmd>RotateWindows<cr>', { desc = 'Rotate Windows' })
vim.keymap.set('n', '<leader>m', '<cmd>MaximizerToggle<CR>', { desc = 'Maximize/minimize a split' })
vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<CR>', { desc = 'Lazygit' })
vim.keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split vertically' })
vim.keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split horizontally' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Make splits equal size' })
vim.keymap.set('n', '<leader>sx', '<cmd>close<CR>', { desc = 'Close current split' })
-- vim.keymap.set('n', '<leader>vv', '<cmd>vert diffsplit version.yml<CR>', { desc = 'Compare Versions' })

vim.keymap.set('n', '<leader>sr', function()
  require('spectre').open()
end, { desc = 'Replace in Files (Spectre)' })

vim.keymap.set('n', 'H', '^', { desc = 'Start of line' })
vim.keymap.set('n', 'L', '$', { desc = 'End of line' })
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)

-- Press gx to open the link under the cursor
vim.keymap.set('n', 'gx', ':sil !open <cWORD><cr>', { silent = true })

-- Center buffer while navigating
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-i>', '<C-i>zz')
vim.keymap.set('n', '<C-o>', '<C-o>zz')
vim.keymap.set('n', '{', '{zz')
vim.keymap.set('n', '}', '}zz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'G', 'Gzz')
vim.keymap.set('n', 'gg', 'ggzz')
vim.keymap.set('n', '%', '%zz')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '#zz')

-- Harpoon keybinds --
-- Open harpoon ui
vim.keymap.set('n', '<leader>ho', function()
  require('harpoon.ui').toggle_quick_menu()
end)

-- Add current file to harpoon
vim.keymap.set('n', '<leader>ha', function()
  require('harpoon.mark').add_file()
end)

vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_next {}
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Next Diagnostic' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_prev {}
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Previous Diagnostic' })

vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR }
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Next Error' })

vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR }
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Previous Error' })

vim.keymap.set('n', '[w', function()
  vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN }
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Next Warning' })

vim.keymap.set('n', ']w', function()
  vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN }
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Previous Warning' })

vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_next()
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Next Todo' })

vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_prev()
  vim.api.nvim_feedkeys('zz', 'n', false)
end, { desc = 'Previous Todo' })

vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.open_float {
    border = 'rounded',
  }
end, { desc = 'Open Diagnostic' })

-- greatest remap ever
-- replace the selected text with the copied text
vim.keymap.set('x', '<leader>p', [["_dP]])

-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])

vim.keymap.set('x', '<<', function()
  -- Move selected text up/down in visual mode
  vim.cmd 'normal! <<'
  vim.cmd 'normal! gv'
end)

vim.keymap.set('x', '>>', function()
  vim.cmd 'normal! >>'
  vim.cmd 'normal! gv'
end)

vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })

-- vim: ts=2 sts=2 sw=2 et
