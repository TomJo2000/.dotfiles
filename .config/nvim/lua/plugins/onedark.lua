local M = {}

-- stylua: ignore
M.palette = {
  black       = '#050307',
  red         = '#DF0D0B',
  green       = '#0AA342',
  yellow      = '#EDBA04',
  blue        = '#0759B6',
  magenta     = '#B7208F',
  cyan        = '#06C2F7',
  light_grey  = '#B0B2B4',
  dark_grey   = '#4F4D4B',
  light_red   = '#EB939B',
  light_green = '#4EAF26',
  orange      = '#F36D11',
  dark_blue   = '#0F2A9F',
  purple      = '#B84FE0',
  zomp        = '#0C8167',
  white       = '#FBF6FD',
}

---@see onedark.style.darker
-- stylua: ignore
M.colors = {
  black       = M.palette.black,       -- #050307
  red         = M.palette.red,         -- #DF0D0B
  green       = M.palette.green,       -- #0AA342
  yellow      = M.palette.yellow,      -- #EDBA04
  blue        = M.palette.blue,        -- #0759B6
  purple      = M.palette.magenta,     -- #B7208F
  cyan        = M.palette.cyan,        -- #06C2F7
  light_grey  = M.palette.light_grey,  -- #B0B2B4
  grey        = M.palette.grey,        -- #4F4D4B
  dark_red    = M.palette.light_red,   -- #EB939B
  light_green = M.palette.light_green, -- #4EAF26
  orange      = M.palette.orange,      -- #F36D11
  dark_blue   = M.palette.dark_blue,   -- #0F2A9F
  dark_purple = M.palette.purple,      -- #B84FE0
  dark_cyan   = M.palette.zomp,        -- #0C8167
  white       = M.palette.white,       -- #FBF6FD
  bg0         = '#1F2329',
  bg1         = '#282C34',
  bg2         = '#30363F',
  bg3         = '#323641',
  bg_d        = '#181B20',
  bg_blue     = '#61AFEF',
  bg_yellow   = '#E8C88C',
  dark_yellow = '#93691D',
  fg          = '#A0A8B7',
  diff_add    = '#272E23',
  diff_delete = '#2D2223',
  diff_change = '#172A3A',
  diff_text   = '#274964',
}

M.opts = { -- Main options
  style = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  transparent = false, -- Show/hide background
  term_colors = false, -- Change terminal color as per the selected theme style
  ending_tildes = true, -- Show the end-of-buffer tildes. By default they are hidden
  cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

  -- Change code style
  code_style = {
    comments = 'italic', -- Options are italic, bold, underline, none
    keywords = 'bold', -- You can configure multiple style with comma separated
    variables = 'none',
  },
  -- Plugins Config
  diagnostics = {
    darker = false, -- darker colors for diagnostic
    undercurl = false, -- use undercurl instead of underline for diagnostics
    background = true, -- use background color for virtual text
  },
  -- Overrides default colors
  colors = {
    unpack(M.colors),
  },
  -- Custom Highlights --
  highlights = { -- Override highlight groups
    CursorLine = { bg = '$bg1' },
  },
}

return M
