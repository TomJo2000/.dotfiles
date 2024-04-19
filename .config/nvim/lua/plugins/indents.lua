return function()

  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  -- stylua: ignore
  -- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  --   vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
  --   vim.api.nvim_set_hl(0, 'RainbowBlue'  , { fg = '#61AFEF' })
  --   vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
    -- vim.api.nvim_set_hl(0, 'RainbowRed'   , { fg = '#E06C75' })
    -- vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
    -- vim.api.nvim_set_hl(0, 'RainbowGreen' , { fg = '#98C379' })
    -- vim.api.nvim_set_hl(0, 'RainbowCyan'  , { fg = '#56B6C2' })
  -- end)

  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes

  local ibl = require('ibl')
  local hooks = require('ibl.hooks')
  local delim = require('rainbow-delimiters')
  local highlight = {
    'RainbowDelimiterViolet',
    'RainbowDelimiterBlue',
    'RainbowDelimiterYellow',
    -- 'RainbowDelimiterRed',
    -- 'RainbowDelimiterOrange',
    -- 'RainbowDelimiterGreen',
    -- 'RainbowDelimiterCyan',
  }

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
  ibl.setup({
    viewport_buffer = { min = 1 },
    indent = {
      -- char = '|'
    },
    -- whitespace = {
    --   highlight = { 'Function', 'Label' },
    -- },
    scope = {
      enabled = true,
      highlight = highlight,
    },
  })

  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end
