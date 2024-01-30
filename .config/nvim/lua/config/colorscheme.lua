---@enum onedark.opts
return {
  style                = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  transparent          = false,    -- Show/hide background
  term_colors          = true,     -- Change terminal color as per the selected theme style
  ending_tildes        = true,     -- Show the end-of-buffer tildes. By default they are hidden
  cmp_itemkind_reverse = false,    -- reverse item kind highlights in cmp menu

  -- Change code style --
  code_style           = {
    comments  = 'italic', -- Options are italic, bold, underline, none
    keywords  = 'bold',   -- You can configure multiple style with comma separated
    functions = 'none',   -- For example., keywords = 'italic,bold'
    strings   = 'none',
    variables = 'none'
  },
  -- Plugins Config --
  diagnostics  = {
    darker     = true, -- darker colors for diagnostic
    undercurl  = true, -- use undercurl instead of underline for diagnostics
    background = true, -- use background color for virtual text
  },
  -- Overrides default colors --
  colors = {},
  -- Custom Highlights --
  highlights           = { -- Override highlight groups
    CursorLine = { bg = '#21252b' }
  },
}
