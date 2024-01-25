#!/usr/bin/env lua

---@type string
local csi = '\x1b['


---@param hex string | number
---@return { r:number, g:number, b:number }
local function hex2rgb(hex)
  hex = hex:gsub('^#', '')
  return {
    r = tonumber('0x' .. hex:sub(1, 2)),
    g = tonumber('0x' .. hex:sub(3, 4)),
    b = tonumber('0x' .. hex:sub(5, 6))
  }
end

local pal = {}


for i = 1, #arg, 2 do
  print(string.format('%-3d%-13s%-3d%s', i, arg[i], i + 1, arg[i+1]))
  pal[arg[i]] = hex2rgb(arg[i+1])
end


-- ---@type { [string]: string[] }
-- local pal = {
--   black       = hex2rgb('#050307'),
--   red         = hex2rgb('#DF0D0B'),
--   green       = hex2rgb('#0AA342'),
--   yellow      = hex2rgb('#EDBA04'),
--   blue        = hex2rgb('#0759B6'),
--   magenta     = hex2rgb('#B7208F'),
--   cyan        = hex2rgb('#06C2F7'),
--   light_grey  = hex2rgb('#B0B2B4'),
--   dark_grey   = hex2rgb('#4F4D4B'),
--   light_red   = hex2rgb('#EB939B'),
--   light_green = hex2rgb('#4EAF26'),
--   orange      = hex2rgb('#F36D11'),
--   dark_blue   = hex2rgb('#0F2A9F'),
--   purple      = hex2rgb('#B84FE0'),
--   zomp        = hex2rgb('#0C8167'),
--   white       = hex2rgb('#FBF6FD'),
-- }

for k, _ in pairs(pal) do
  local triplet = string.format("%d;%d;%d", pal[k].r, pal[k].g, pal[k].b )
  local luma = ((299 * pal[k].r) + (587 * pal[k].g) + (114 * pal[k].b) ) / 2550
  io.write(
    k .. "='\x1b[38;2;" .. triplet .. 'm' .. triplet .. "\x1b[m' Luma: " .. string.format('%.2f%%', luma) .. "\n"
  )
end

-- for k, v in pairs(palette) do
--   io.write(k .. "='" .. string.format('%d;%d;%d', hex2rgb(v) ) .. "'\n")
-- end
--
--
-- local min = { r = math.min(table.unpack(pal.r)), g = math.min(table.unpack(pal.r)), b = math.min(table.unpack(pal.r)) }
-- local max = { r = math.max(table.unpack(pal.r)), g = math.max(table.unpack(pal.r)), b = math.max(table.unpack(pal.r)) }
--
-- io.write(pairs(min), pairs(max))
--
