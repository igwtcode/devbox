return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'ThePrimeagen/harpoon', 'nvim-tree/nvim-web-devicons' },
  config = function()
    local lualine = require 'lualine'
    local harpoon = require 'harpoon.mark'

    local function harpoon_component()
      local total_marks = harpoon.get_length()

      if total_marks == 0 then
        return ''
      end

      local current_mark = '—'

      local mark_idx = harpoon.get_current_index()
      if mark_idx ~= nil then
        current_mark = tostring(mark_idx)
      end

      return string.format('󱡅 %s/%d', current_mark, total_marks)
    end

    lualine.setup {
      options = {
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          -- "buffers",
          { 'branch', icon = '' },
          harpoon_component,
          'diff',
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            sections = { 'error', 'warn', 'info', 'hint' },

            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = ' ',
            },
          },
        },
        lualine_c = {
          { 'filename', path = 1 },
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    }
  end,
}
