return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'onsails/lspkind.nvim',
      'windwp/nvim-ts-autotag',
      'windwp/nvim-autopairs',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('nvim-autopairs').setup()
      luasnip.config.setup {}

      cmp.setup {
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        sorting = {
          priority_weight = 10.0,
          comparators = {
            cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
            cmp.config.compare.locality,
            cmp.config.compare.recently_used,
            cmp.config.compare.offset,
            cmp.config.compare.order,
            -- cmp.config.compare.kind,
            -- compare.exact,
            -- compare.scopes, -- what?
            -- compare.sort_text,
            -- compare.length, -- useless
            -- compare.score_offset, -- not good at all
          },
        },

        formatting = {
          fields = { 'kind', 'abbr' },
          -- fields = { 'kind', 'abbr', 'menu' },
          expandable_indicator = false,
          format = require('lspkind').cmp_format {
            mode = 'symbol',
            preset = 'codicons',
            -- mode = 'symbol_text',
            maxwidth = {
              abbr = 30,
              menu = 0,
            },
            maxHeight = 18,
            ellipsis_char = '...',
            symbol_map = {
              Copilot = '',
            },
          },
        },
        experimental = {
          ghost_text = true,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        mapping = cmp.mapping.preset.insert {
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<TAB>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm { select = true },

          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = cmp.config.sources {
          { name = 'copilot', priority = 10 },
          { name = 'nvim_lsp', priority = 9 },
          { name = 'buffer', priority = 8, max_item_count = 7 }, -- text within current buffer
          { name = 'luasnip', priority = 7, max_item_count = 7 }, -- snippets
          { name = 'path', priority = 6, max_item_count = 7 }, -- file system paths
          { name = 'spell', keyword_length = 3, priority = 5, keyword_pattern = [[\w\+]] },
          { name = 'nerdfont', priority = 3 },
          { name = 'calc', priority = 3 },
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
        },
      }

      cmp.setup.filetype({ 'sql' }, {
        sources = {
          { name = 'vim-dadbod-completion' },
          { name = 'buffer' },
        },
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
