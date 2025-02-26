-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable default fileexplorer netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- [[ Setting options ]]
require 'options'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Basic Commands ]]
require 'commands'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
