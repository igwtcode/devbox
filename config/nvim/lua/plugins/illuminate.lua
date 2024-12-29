return {
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost' },
    config = function()
      require('illuminate').configure {
        delay = 500,
        providers = {
          'lsp',
          'regex',
          'treesitter',
        },
        large_file_cutoff = 3000,
        large_file_overrides = {
          providers = { 'lsp' },
        },
        filetypes_denylist = {
          'mason',
          'harpoon',
          'DressingInput',
          'NeogitCommitMessage',
          'qf',
          'dirvish',
          'oil',
          'minifiles',
          'fugitive',
          'alpha',
          'NvimTree',
          'lazy',
          'NeogitStatus',
          'Trouble',
          'netrw',
          'lir',
          'DiffviewFiles',
          'Outline',
          'Jaq',
          'spectre_panel',
          'toggleterm',
          'DressingSelect',
          'TelescopePrompt',
        },
      }

      local function map(key, dir, buffer)
        vim.keymap.set('n', key, function()
          require('illuminate')['goto_' .. dir .. '_reference'](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer })
      end

      map('[i', 'next')
      map(']i', 'prev')

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map('[i', 'next', buffer)
          map(']i', 'prev', buffer)
        end,
      })
    end,
  },
}
