return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'olacin/telescope-cc.nvim',
      'folke/todo-comments.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-tree/nvim-web-devicons' },
      { 'folke/trouble.nvim', event = 'VeryLazy', dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/todo-comments.nvim' } },
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      local actions = require 'telescope.actions'
      local transform_mod = require('telescope.actions.mt').transform_mod
      local pickers = require 'telescope.pickers'
      local finders = require 'telescope.finders'
      local sorters = require 'telescope.sorters'

      function View_messages()
        local messages = vim.fn.execute 'messages'
        local lines = vim.split(messages, '\n')
        pickers
          .new({ initial_mode = 'normal' }, {
            prompt_title = 'Messages',
            finder = finders.new_table {
              results = lines,
            },
            sorter = sorters.get_generic_fuzzy_sorter(),
          })
          :find()
      end

      local trouble = require 'trouble'
      local trouble_telescope = require 'trouble.sources.telescope'

      -- or create your custom action
      local custom_actions = transform_mod {
        open_trouble_qflist = function(prompt_bufnr)
          trouble.toggle 'quickfix'
        end,
      }

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = vim.tbl_extend('force', require('telescope.themes').get_ivy(), {
          layout_config = {
            height = 0.72,
          },
          preview = {
            filesize_limit = 3, -- MB
          },
          mappings = {
            n = {
              ['dd'] = actions.delete_buffer,
            },
            i = {
              ['<C-k>'] = actions.move_selection_previous, -- move to prev result
              ['<C-j>'] = actions.move_selection_next, -- move to next result
              ['<C-q>'] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
              ['<C-t>'] = trouble_telescope.open,
            },
          },
          vimgrep_arguments = {
            'rg',
            '--follow', -- Follow symbolic links
            '--hidden', -- [F]ind for hidden files
            '--no-heading', -- Don't group matches by each file
            '--with-filename', -- Print the file path with the matched lines
            '--line-number', -- Show line numbers
            '--column', -- Show column numbers
            '--smart-case', -- Smart case search

            -- Exclude some patterns from search
            '--glob=!**/.git/*',
            '--glob=!**/.idea/*',
            '--glob=!**/.vscode/*',
            '--glob=!**/build/*',
            '--glob=!**/dist/*',
            '--glob=!**/*.zip',
            '--glob=!**/yarn.lock',
            '--glob=!**/package-lock.json',
          },
        }),
        pickers = {
          find_files = {
            hidden = true,
            find_command = {
              'rg',
              '--files',
              '--hidden',
              -- "--no-ignore-vcs",
              '--glob=!**/.git/*',
              '--glob=!**/.idea/*',
              '--glob=!**/.vscode/*',
              '--glob=!**/build/*',
              '--glob=!**/dist/*',
              '--glob=!**/*.zip',
              '--glob=!**/yarn.lock',
              '--glob=!**/package-lock.json',
            },
          },
          live_grep = {
            hidden = true,
          },
          buffers = {
            sort_lastused = true,
            ignore_current_buffer = false,
            show_all_buffers = true,
            initial_mode = 'normal',
            sort_mru = true,
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
          },
          conventional_commits = {
            include_body_and_footer = false, -- Add prompts for commit body and footer
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'conventional_commits')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = '[F]ind Recent Files' })
      vim.keymap.set('n', '<leader>f.', builtin.buffers, { desc = '[F]ind existing buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
      vim.keymap.set('n', '<leader>fm', View_messages, { desc = '[F]ind [R]esume' })
      vim.keymap.set('n', '<leader>ft', '<cmd>TodoTelescope initial_mode=normal<cr>', { desc = 'Find todos' })
      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })
      -- vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })

      -- vim.keymap.set('n', '<leader>ld', vim.diagnostic.setqflist, { desc = 'Quickfix List Diagnostics' })
      vim.keymap.set('n', '<leader>ss', '<cmd>Telescope spell_suggest<CR>', { desc = '[S]pell [S]uggestions' })
      vim.keymap.set('n', '<leader>cc', '<cmd>Telescope conventional_commits<CR>', { desc = 'Conventional Commit' })
      vim.keymap.set('n', '<leader>cn', ':cnext<cr>zz', { desc = 'Next Quickfix' })
      vim.keymap.set('n', '<leader>cp', ':cprevious<cr>zz', { desc = 'Previous Quickfix' })
      vim.keymap.set('n', '<leader>co', ':copen<cr>zz', { desc = 'Open Quickfix' })
      -- vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<CR>', { desc = 'Open/close trouble list' })
      -- vim.keymap.set('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<CR>', { desc = 'Open trouble workspace diagnostics' })
      -- vim.keymap.set('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<CR>', { desc = 'Open trouble document diagnostics' })
      -- vim.keymap.set('n', '<leader>xq', '<cmd>TroubleToggle quickfix<CR>', { desc = 'Open trouble quickfix list' })
      -- vim.keymap.set('n', '<leader>xl', '<cmd>TroubleToggle loclist<CR>', { desc = 'Open trouble location list' })
      -- vim.keymap.set('n', '<leader>xt', '<cmd>TodoTrouble<CR>', { desc = 'Open todos in trouble' })

      -- Slightly advanced example of overriding default behavior and theme
      -- vim.keymap.set('n', '<leader>/', function()
      --   -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      --   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      --     winblend = 0,
      --     previewer = false,
      --   })
      -- end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[F]ind [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[F]ind [N]eovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
