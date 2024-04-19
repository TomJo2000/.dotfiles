local M = {}

---@see onedark.style.darker
M.colors = {
  black = '#0e1013',
  bg0 = '#1f2329',
  bg1 = '#282c34',
  bg2 = '#30363f',
  bg3 = '#323641',
  bg_d = '#181b20',
  bg_blue = '#61afef',
  bg_yellow = '#e8c88c',
  fg = '#a0a8b7',
  purple = '#bf68d9',
  green = '#8ebd6b',
  orange = '#cc9057',
  blue = '#4fa6ed',
  yellow = '#e2b86b',
  cyan = '#48b0bd',
  red = '#e55561',
  grey = '#535965',
  light_grey = '#7a818e',
  dark_cyan = '#266269',
  dark_red = '#8b3434',
  dark_yellow = '#835d1a',
  dark_purple = '#7e3992',
  diff_add = '#272e23',
  diff_delete = '#2d2223',
  diff_change = '#172a3a',
  diff_text = '#274964',
}

M.config = { -- Main options --
  style = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  transparent = false, -- Show/hide background
  term_colors = true, -- Change terminal color as per the selected theme style
  ending_tildes = true, -- Show the end-of-buffer tildes. By default they are hidden
  cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

  -- Change code style --
  code_style = {
    comments = 'italic', -- Options are italic, bold, underline, none
    keywords = 'bold', -- You can configure multiple style with comma separated
    functions = 'none', -- For example., keywords = 'italic,bold'
    strings = 'none',
    variables = 'none',
  },
  -- Plugins Config --
  diagnostics = {
    darker = false, -- darker colors for diagnostic
    undercurl = false, -- use undercurl instead of underline for diagnostics
    background = true, -- use background color for virtual text
  },
  -- Overrides default colors --
  colors = {},
  -- Custom Highlights --
  highlights = { -- Override highlight groups
    CursorLine = { bg = '#21252b' },
  },
}

return M
