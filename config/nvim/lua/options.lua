-- [[ Setting options ]]
-- See `:help vim.opt`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = false

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 300

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 360

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15
vim.opt.sidescrolloff = 15

-- convert tabs to spaces
vim.opt.expandtab = true

-- the number of spaces inserted for each indentation
vim.opt.shiftwidth = 2

-- the number of spaces inserted for a tab
vim.opt.softtabstop = 2

-- insert 2 spaces for a tab
vim.opt.tabstop = 2

-- show search matches as you type
vim.opt.incsearch = true

-- make indenting smarter again
vim.opt.smartindent = true

-- copy indent from current line
vim.opt.autoindent = true

-- no backup file
vim.opt.backup = false

-- don't create a swapfile
vim.opt.swapfile = false

-- the encoding displayed
vim.opt.encoding = 'utf-8'

-- the encoding written to a file
vim.opt.fileencoding = 'utf-8'

-- disable error bells
vim.opt.errorbells = false

-- allow hidden buffers
vim.opt.hidden = true

-- set number column width to 4
vim.opt.numberwidth = 4

-- display lines as one long line
vim.opt.wrap = false

-- companion to wrap don't split words
vim.opt.linebreak = true

-- so that I can see `` in markdown files
vim.opt.conceallevel = 0

-- highlight all matches on previous search pattern
vim.opt.hlsearch = true

-- set term gui colors (most terminals support this)
vim.opt.termguicolors = true

-- hyphenated words recognized by searches
vim.opt.iskeyword:append '-'

-- fold based on treesitter
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr'

vim.opt.modeline = true
vim.opt.guicursor = 'a:hor100-blinkon1'

-- vim: ts=2 sts=2 sw=2 et
