-- return {
--   "folke/tokyonight.nvim",
--   lazy = true,
--   opts = {
--     style = "night",
--     transparent = true,
--     on_highlights = function(hl, c)
--       hl.WinSeparator = { fg = c.dark3, bg = "NONE" }
--     end,
--   },
-- }
return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
      background = { light = "latte", dark = "mocha" },
      transparent_background = true, -- disables setting the background color.
      -- color_overrides = {
      --   mocha = {
      --     base = "#121212",
      --     mantle = "#121212",
      --     crust = "#121212",
      --   },
      -- },
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.39,
      },
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("catppuccin") then
            opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
          end
        end,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
