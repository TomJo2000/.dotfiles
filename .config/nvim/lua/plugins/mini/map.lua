local MiniMap = require('mini.map')
local M = {}

MiniMap.setup()

M.binds = {
  { 'n', '<Leader>mm', MiniMap.toggle, { desc = '[M]ini.[m]ap toggle' } },
  { 'n', '<Leader>mo', MiniMap.open, { desc = '[M]ini.map [o]pen' } },
  { 'n', '<Leader>mc', MiniMap.close, { desc = '[M]ini.map [c]lose' } },
  { 'n', '<Leader>mr', MiniMap.refresh, { desc = '[M]ini.map [r]efresh' } },
}

M.config = {
  -- stylua: ignore
  integrations = {
    MiniMap.gen_integration.builtin_search(),
    MiniMap.gen_integration.diagnostic({
      error = 'DiagnosticFloatingError',
      warn  = 'DiagnosticFloatingWarn',
      info  = 'DiagnosticFloatingInfo',
      hint  = 'DiagnosticFloatingHint',
    }),
    MiniMap.gen_integration.gitsigns({
      add    = 'GitSignsAdd',
      change = 'GitSignsChange',
      delete = 'GitSignsDelete',
    }),
  },
  symbols = {
    scroll_line = '⦿',
    scroll_view = '┃',
    encode = MiniMap.gen_encode_symbols.dot('4x2'),
  },
  window = {
    side = 'right',
    width = math.floor(vim.o.columns / 9),
    winblend = 70, -- This looks about right to me
    show_integration_count = true,
  },
}

return M
