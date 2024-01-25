#!/usr/bin/env lua

---@type string
local ls_colors = os.getenv('LS_COLORS') or ''

---@param colors string | number
local function ls_parse(colors)
  for word in string.gmatch(colors, '[^:]+') do
    local match, _ = word:gsub('^.+=','')
    io.write('\x1b[' .. match .. 'm' .. word .. '\x1b[m:')
  end
  print()
  -- return colors
end

ls_parse(ls_colors)

