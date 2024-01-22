---@return table onedark.opts
return {
  style                = 'darker',     -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  transparent          = false,        -- Show/hide background
  term_colors          = true,         -- Change terminal color as per the selected theme style
  ending_tildes        = true,         -- Show the end-of-buffer tildes. By default they are hidden
  cmp_itemkind_reverse = false,        -- reverse item kind highlights in cmp menu

  -- Change code style --
  code_style           = {
    comments  = 'italic',     -- Options are italic, bold, underline, none
    keywords  = 'bold',       -- You can configure multiple style with comma separated
    functions = 'none',       -- For example., keywords = 'italic,bold'
    strings   = 'none',
    variables = 'none'
  },
  -- Plugins Config --
  diagnostics          = {
    darker     = true,     -- darker colors for diagnostic
    undercurl  = true,     -- use undercurl instead of underline for diagnostics
    background = true,     -- use background color for virtual text
  },
  -- Custom Highlights --
  highlights           = {},     -- Override highlight groups
  -- Override default colors --
  colors               = {
    black       = '#181a1f',
    bg0         = '#282c34',
    bg1         = '#31353f',
    bg2         = '#393f4a',
    bg3         = '#3b3f4c',
    bg_d        = '#21252b',
    bg_blue     = '#73b8f1',
    bg_yellow   = '#ebd09c',
    fg          = '#abb2bf',
    purple      = '#c678dd',
    green       = '#98c379',
    orange      = '#d19a66',
    blue        = '#61afef',
    yellow      = '#e5c07b',
    cyan        = '#56b6c2',
    red         = '#e86671',
    grey        = '#5c6370',
    light_grey  = '#848b98',
    dark_cyan   = '#2b6f77',
    dark_red    = '#993939',
    dark_yellow = '#93691d',
    dark_purple = '#8a3fa0',
    diff_add    = '#31392b',
    diff_delete = '#382b2c',
    diff_change = '#1c3448',
    diff_text   = '#2c5372',
  },
}

