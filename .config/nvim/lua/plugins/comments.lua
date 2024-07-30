local theme = require('plugins.onedark').colors

return {
  signs = true, -- show icons in the signs column
  sign_priority = 8, -- sign priority
  -- keywords recognized as todo comments
  -- stylua: ignore
  keywords = {
    FIX = {
      icon = ' ', -- icon used for the sign, and in search results
      color = 'error', -- can be a hex color, or a named color (see below)
      alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    ['**']      = { icon = '*', color = '#0AA342', --[[ alt = {} ]]},
    ['><']      = { icon = '>', color = '#0C8167', --[[ alt = {} ]]},
    ['??']      = { icon = '?', color = '#0759B6', --[[ alt = {} ]]},
    ['<>']      = { icon = '<', color = '#0F2A9F', --[[ alt = {} ]]},
    ['|>']      = { icon = '|', color = '#B7208F', --[[ alt = {} ]]},
    ['!!']      = { icon = '!', color = '#DF0D0B', --[[ alt = {} ]]},
    ['~~']      = { icon = '~', color = '#4F4D4B', --[[ alt = {} ]]},
    ['(TODO)']  = { icon = 'T', color = '#EDBA04', --[[ alt = {} ]]},
    ['(WIP)']   = { icon = 'W', color = '#F36D11', --[[ alt = {} ]]},
    ['(ACK)']   = { icon = 'A', color = '#B84FE0', --[[ alt = {} ]]},
    ['(RegEx)'] = { icon = 'R', color = '#0759B6', --[[ alt = {} ]]},
  },
  merge_keywords = false, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  highlight = {
    multiline = true, -- enable multine todo comments
    multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
    multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
    before = '', -- "fg" or "bg" or empty
    keyword = 'wide', -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
    after = 'fg', -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = { 'help', 'lazy', 'man' }, -- list of file types to exclude highlighting
  },
  -- list of named colors where we try to extract the guifg from the
  -- list of highlight groups or use the hex color if hl not found as a fallback
  search = {
    command = 'rg',
    args = {
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
}
