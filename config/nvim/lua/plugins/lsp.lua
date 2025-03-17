return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      yamlls = {
        filetypes = { "yaml", "yaml.ansible", "yaml.github", "yaml.cfn", "yaml.sam" },
      },
      gopls = {
        settings = {
          gopls = {
            usePlaceholders = false,
          },
        },
      },
    },
  },
}
