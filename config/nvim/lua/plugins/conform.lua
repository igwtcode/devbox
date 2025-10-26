return {
  "stevearc/conform.nvim",
  opts = function()
    ---@type conform.setupOpts
    local opts = {
      formatters_by_ft = {
        terraform = { 'terraform_fmt' },
        tf = { 'terraform_fmt' },
        ['terraform-vars'] = { 'terraform_fmt' },
        ["javascript"] = { "biome", "prettier" , stop_after_first = true},
        ["javascriptreact"] = { "biome", "prettier" , stop_after_first = true},
        ["typescript"] = { "biome", "prettier" , stop_after_first = true},
        ["typescriptreact"] = { "biome", "prettier" , stop_after_first = true},
        ["json"] = { "biome", "prettier" , stop_after_first = true},
        ["jsonc"] = { "biome", "prettier" , stop_after_first = true},
        ["css"] = { "biome", "prettier" , stop_after_first = true},
        ["markdown"] = { "prettier" , stop_after_first = true},
        ["md"] = { "prettier" , stop_after_first = true},
      },
      -- The options you set here will be merged with the builtin formatters.
      -- You can also define any custom formatters here.
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        biome = {
          command = "biome",
          args = {
            "check",
            "--formatter-enabled=true",
            "--linter-enabled=true",
            "--enforce-assist=true",
            "--write",
            "--stdin-file-path",
            "$FILENAME",
          },
        },
      },
    }
    return opts
  end,
}
