local delim = require('rainbow-delimiters')

return {
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
  highlight = {
    'RainbowDelimiterViolet',
    'RainbowDelimiterBlue',
    'RainbowDelimiterYellow',
  },
}
