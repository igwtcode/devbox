return {
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    config = function()
      local ts_context_commentstring = require 'ts_context_commentstring.integrations.comment_nvim'

      -- Comment configuration object _can_ take a partial and is merged in
      ---@diagnostic disable-next-line: missing-fields
      require('Comment').setup {
        -- for commenting tsx, jsx, svelte, html files
        pre_hook = ts_context_commentstring.create_pre_hook(),
        mappings = {
          ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          basic = true,
          ---Extra mapping; `gco`, `gcO`, `gcA`
          extra = false,
        },
      }

      local ft = require 'Comment.ft'
      ft.set('reason', { '//%s', '/*%s*/' })
    end,
  },
}
