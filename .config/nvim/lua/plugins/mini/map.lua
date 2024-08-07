local M = {}

-- stylua: ignore
M.binds = function()
local MiniMap = require('mini.map')
  return {
    { '<Leader>mo', MiniMap.open   , { mode = 'n', desc = '[M]ini.map [o]pen' }    },
    { '<Leader>mc', MiniMap.close  , { mode = 'n', desc = '[M]ini.map [c]lose' }   },
    { '<Leader>mm', MiniMap.toggle , { mode = 'n', desc = '[M]ini.[m]ap toggle' }  },
    { '<Leader>mr', MiniMap.refresh, { mode = 'n', desc = '[M]ini.map [r]efresh' } },
  }
end

M.config = function()
  local MiniMap = require('mini.map')
  MiniMap.setup({
  -- stylua: ignore
  integrations = {
    MiniMap.gen_integration.builtin_search(),
    MiniMap.gen_integration.diagnostic({
      error = 'DiagnosticFloatingError',
      warn  = 'DiagnosticFloatingWarn',
      info  = 'DiagnosticFloatingInfo',
      hint  = 'DiagnosticFloatingHint',
    }),
    MiniMap.gen_integration.diff(),
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
      winblend = 70, -- This looks about right to me
      show_integration_count = false,
      width = math.floor(vim.o.columns / 9),
      zindex = 10,
    },
  })
end

return M
