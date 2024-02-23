#!/usr/bin/env luajit

local script_root = arg[0]:match('@?(.*/)') or ''
package.path = ('%s?.lua;'):format(script_root) .. package.path

---@source ./lua/trilerp.lua
local t = require('lua.trilerp')
---@type rgb[]
local pal = {}

for i = 1, #arg, 2 do
  print(string.format('%-3d%-13s%-3d%s', i, arg[i], i + 1, arg[i + 1]))
  pal[i] = { tostring(arg[i]), t.hex2rgb(arg[i + 1]) }
end
local num_basecolors = #pal

-- for k, _ in pairs(pal) do
--   local triplet = string.format("%d;%d;%d", pal[k].r, pal[k].g, pal[k].b )
--   local luma = (299 * pal[k].r) + (587 * pal[k].g) + (114 * pal[k].b)
--   io.write(string.format("%s='\x1b[38;2;%sm%s\x1b[m Luma: %.2f%%\n", k, triplet, triplet, luma / 2550))
-- end

-- Greyscale
for i = 1, 24 do
  pal[#pal + 1] = t.rgb_trilerp({ pal[1], pal[num_basecolors] }, i, i, i)
end
