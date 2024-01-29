#!/usr/bin/env luajit
package.path = './lua/?.lua;' .. package.path
---@source ./lua/trilerp.lua
local t = require('trilerp')
local pal = {}


for i = 1, #arg, 2 do
  print(string.format('%-3d%-13s%-3d%s', i, arg[i], i + 1, arg[i+1]))
  pal[arg[i]] = t.hex2rgb(arg[i+1])
end

for k, _ in pairs(pal) do
  local triplet = string.format("%d;%d;%d", pal[k].r, pal[k].g, pal[k].b )
  local luma = ((299 * pal[k].r) + (587 * pal[k].g) + (114 * pal[k].b) ) / 2550
  io.write(string.format("%s='\x1b[38;2;%sm%s\x1b[m Luma: %.2f%%\n", k, triplet, triplet, luma))
end
