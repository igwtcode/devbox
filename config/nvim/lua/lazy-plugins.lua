local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  { 'ThePrimeagen/harpoon', lazy = true },
  { 'szw/vim-maximizer', event = 'VeryLazy' },
  {
    'folke/zen-mode.nvim',
    opts = { window = { width = 150 } },
  },
  {
    'alexghergh/nvim-tmux-navigation',
    event = 'VeryLazy',
    config = function()
      require('nvim-tmux-navigation').setup {
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = '<C-h>',
          down = '<C-j>',
          up = '<C-k>',
          right = '<C-l>',
        },
      }
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    event = { 'VeryLazy' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
  },
  {
    'nvim-pack/nvim-spectre',
    build = false,
    cmd = 'Spectre',
    event = 'VeryLazy',
    opts = { open_cmd = 'noswapfile vnew' },
  },
  {
    'zbirenbaum/copilot-cmp',
    event = 'InsertEnter',
    config = function()
      require('copilot_cmp').setup()
    end,
    dependencies = {
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      config = function()
        require('copilot').setup {
          suggestion = { enabled = true },
          panel = { enabled = true },
        }
      end,
    },
  },
  -- {
  --   'rest-nvim/rest.nvim',
  --   event = { 'VeryLazy' },
  --   cmd = { 'Rest' },
  -- },
  -- {
  --   'jamcco/markdown-preview.nvim',
  --   cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  --   build = 'cd app && npm install',
  --   init = function()
  --     vim.g.mkdp_filetypes = { 'markdown' }
  --   end,
  --   ft = 'markdown',
  -- },

  { import = 'plugins' },
}, {
  concurrency = 18,
  checker = {
    enabled = true,
    notify = false,
    concurrency = 27,
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = 'rounded',
    backdrop = 89,
  },
})

-- vim: ts=2 sts=2 sw=2 et
