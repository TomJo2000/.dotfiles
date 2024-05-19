local M = {}

local highlight = {
  'RainbowDelimiterViolet',
  'RainbowDelimiterBlue',
  'RainbowDelimiterYellow',
}

M.rainbow_delimiters = function()
  local delim = require('rainbow-delimiters')
  vim.g.rainbow_delimiters = {
    strategy = {
      [''] = delim.strategy['global'],
      vim = delim.strategy['local'],
    },
    query = {
      [''] = 'rainbow-delimiters',
      lua = 'rainbow-blocks',
    },
    priority = {
      [''] = 110,
      lua = 210,
    },
    highlight = highlight,
  }
end

M.ibl = function()
  local hooks = require('ibl.hooks')
  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

  require('ibl').setup({
    viewport_buffer = { min = 1 },
    scope = {
      enabled = true,
      highlight = highlight,
    },
    exclude = {
      filetypes = { 'checkhealth', 'diff', 'help', 'lspinfo', 'man', '' },
    },
  })
end

return M
