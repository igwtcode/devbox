return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        -- markdown = { 'markdownlint' },
        dockerfile = { 'hadolint' },
        terraform = { 'tflint' },
        tf = { 'tflint' },
        python = { 'flake8' },
        json = { 'jsonlint' },
        javascript = { 'eslint' },
        typescript = { 'eslint' },
        vue = { 'eslint' },
        ['yaml.github'] = { 'actionlint' },
        ['yaml.cfn'] = { 'cfn_lint' },
        ['yaml.sam'] = { 'cfn_lint' },
      }

      lint.default_severity = {
        ['error'] = vim.diagnostic.severity.ERROR,
        ['warning'] = vim.diagnostic.severity.WARN,
        ['information'] = vim.diagnostic.severity.INFO,
        ['hint'] = vim.diagnostic.severity.HINT,
      }

      local cfnln = lint.linters.cfn_lint
      -- cfnln.cmd = "cfn-lint"
      cfnln.stdin = false
      cfnln.append_fname = true
      cfnln.ignore_exitcode = true
      cfnln.args = {
        '--ignore-checks=E2531',
        '--ignore-checks=W2531',
        -- "--append-rules=cfn_lint_serverless.rules",
        '--format=parseable',
        '-',
      }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint(nil, { ignore_errors = true })
        end,
      })
    end,
  },
}
