return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },

    config = function()
      local conform = require 'conform'

      conform.setup {
        notify_on_error = false,
        format_on_save = function(bufnr)
          -- Disable "format_on_save lsp_fallback" for languages that don't
          -- have a well standardized coding style. You can add additional
          -- languages here or re-enable it for the disabled ones.
          local disable_filetypes = { c = true, cpp = true }
          local lsp_format_opt
          if disable_filetypes[vim.bo[bufnr].filetype] then
            lsp_format_opt = 'never'
          else
            lsp_format_opt = 'fallback'
          end
          return {
            timeout_ms = 500,
            lsp_format = lsp_format_opt,
          }
        end,
        formatters = {
          shfmt = {
            prepend_args = { '-i', '2' },
          },
          beautysh = {
            prepend_args = { '-i', '2', '--force-function-style', 'paronly', '$FILENAME' },
          },
          custom_prettier = {
            command = 'prettier',
            stdin = true,
            args = {
              '--stdin-filepath',
              '$FILENAME',
              '--config',
              os.getenv 'HOME' .. '/prettierrc',
              '--write',
            },
          },
        },
        formatters_by_ft = {
          lua = { 'stylua' },
          go = { 'goimports', 'gofumpt', 'gofmt' },
          python = { 'isort', 'black' },
          terraform = { 'terraform_fmt' },
          tf = { 'terraform_fmt' },
          ['terraform-vars'] = { 'terraform_fmt' },
          sh = { 'shfmt', 'beautysh' },
          bash = { 'shfmt', 'beautysh' },
          zsh = { 'shfmt', 'beautysh' },
          yaml = { 'custom_prettier' },
          ['yaml.cfn'] = { 'custom_prettier' },
          ['yaml.sam'] = { 'custom_prettier' },
          markdown = { 'prettier' },
          ['markdown.mdx'] = { 'prettier' },
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          vue = { 'prettier' },
          handlebars = { 'prettier' },
          html = { 'prettier' },
          css = { 'prettier' },
          sass = { 'prettier', 'stylelint' },
          -- json = { 'custom_prettier' },
          -- jsonc = { 'custom_prettier' },
          -- yaml = { 'prettier', 'custom_prettier', stop_after_first = true },
        },
      }

      -- vim.api.nvim_create_autocmd('BufWritePre', {
      --   group = vim.api.nvim_create_augroup('autoformat', {}),
      --   pattern = '*',
      --   desc = 'Run conform pre save',
      --   callback = function()
      --     conform.format { async = true, lsp_format = 'fallback' }
      --   end,
      -- })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
