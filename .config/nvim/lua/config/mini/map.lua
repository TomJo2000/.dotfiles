local MiniMap = require('mini.map')
MiniMap.setup()

return {
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
