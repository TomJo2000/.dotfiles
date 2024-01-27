#!/usr/bin/env lua
local ls_colors = os.getenv('LS_COLORS') or ''

for word in string.gmatch(ls_colors, '[^:]+') do
  local match, _ = word:gsub('^.+=', '')
  io.write(string.format('\x1b[%sm%s\x1b[m:', match, word))
end
print()
