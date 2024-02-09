#!/usr/bin/env luajit
-- trilerp.lua

---@param colors rgb[] # named or numbered RGB triplets
---@return verts       # RGB triplets for min, max and difference between them
local function find_verts(colors)
  -- stylua: ignore
  ---@type { min: rgb, max: rgb, r: integer, g: integer, b: integer }
  local diffs = {
    min = { r = 255, g = 255, b = 255 },
    max = { r = 0  , g = 0  , b = 0 },
    r = 0, g = 0, b = 0,
  }

  local min, max = diffs.min, diffs.max
  for k, _ in pairs(colors) do
    -- get minimum values
    min.r = min.r < colors[k].r and min.r or colors[k].r
    min.g = min.g < colors[k].g and min.g or colors[k].g
    min.b = min.b < colors[k].b and min.b or colors[k].b

    -- get maximum values
    max.r = max.r > colors[k].r and max.r or colors[k].r
    max.g = max.g > colors[k].g and max.g or colors[k].g
    max.b = max.b > colors[k].b and max.b or colors[k].b
  end
  diffs.r = diffs.max.r - diffs.min.r
  diffs.g = diffs.max.g - diffs.min.g
  diffs.b = diffs.max.b - diffs.min.b

  ---@alias verts { ['rgb'|'rgB'|'rGb'|'rGB'|'Rgb'|'RgB'|'RGb'|'RGB']: rgb }
  return { -- vertices
    ['rgb'] = { r = diffs.min.r, g = diffs.min.g, b = diffs.min.b },
    ['rgB'] = { r = diffs.min.r, g = diffs.min.g, b = diffs.max.b },
    ['rGb'] = { r = diffs.min.r, g = diffs.max.g, b = diffs.min.b },
    ['rGB'] = { r = diffs.min.r, g = diffs.max.g, b = diffs.max.b },
    ['Rgb'] = { r = diffs.max.r, g = diffs.min.g, b = diffs.min.b },
    ['RgB'] = { r = diffs.max.r, g = diffs.min.g, b = diffs.max.b },
    ['RGb'] = { r = diffs.max.r, g = diffs.max.g, b = diffs.min.b },
    ['RGB'] = { r = diffs.max.r, g = diffs.max.g, b = diffs.max.b },
  }
end

local M = {} -- return table

---@alias rgb {r: integer, g: integer, b: integer}
---@alias hex2rgb fun(hex): rgb|rgb[]
---@param hex string|string[] # One or more Hex colors
---@return rgb|rgb[] triplet  # One or more RGB triplets
function M.hex2rgb(hex)
  -- recurse if we've been handed a table
  if type(hex) == 'table' then
    local ret = {}
    for k, v in pairs(hex) do
      ret[k] = M.hex2rgb(v)
    end
    return ret
  end
  assert(hex ~= nil, "Can't convert a nil value to RGB")
  hex = hex:gsub('^#', '')
  if #hex == 3 then
    local r, g, b = hex:match('(.)(.)(.)')
    hex = r:rep(2) .. g:rep(2) .. b:rep(2)
  end
  assert(#hex:match('%x*') == 6, 'invalid hex: ' .. hex)
  local r, g, b = hex:match('(..)(..)(..)')
  return {
    r = tonumber('0x' .. r),
    g = tonumber('0x' .. g),
    b = tonumber('0x' .. b),
  }
end

---Find the vertices for the corresponding set of dimensions
---@alias lerp fun( lerp:{from:rgb, to:rgb}, step:float): rgb
---@param lerp rgb[] # *2 RGB tuple*
---@param step float # *Step*
---@return rgb
function M.rgb_lerp(lerp, step)
  return {
    r = lerp[1].r * (1 - step) + lerp[2].r * step,
    g = lerp[1].g * (1 - step) + lerp[2].g * step,
    b = lerp[1].b * (1 - step) + lerp[2].b * step,
  }
end

---@alias bilerp table<lerp, lerp, float, float>
---@param colors rgb[]
---@param x_step float # x-axis correction factor
---@param y_step float # y-axis correction factor
---@return rgb
function M.rgb_bilerp(colors, x_step, y_step)
  local v = type(colors[1]) == 'table' and colors or find_verts(colors)
  return M.rgb_lerp({
    M.rgb_lerp({ v[1], v[2] }, x_step),
    M.rgb_lerp({ v[3], v[4] }, x_step),
  }, y_step)
end

---@alias trilerp table<bilerp, bilerp, float, float, float>
---@param colors rgb[]
---@param x_step float # x-axis correction factor
---@param y_step float # y-axis correction factors
---@param z_step float # z-axis correction factors
---@return rgb
function M.rgb_trilerp(colors, x_step, y_step, z_step)
  local v = type(colors[1]) == 'table' and colors or find_verts(colors)
  return M.rgb_lerp({
    M.rgb_bilerp({ v[1], v[2], v[3], v[4] }, x_step, y_step),
    M.rgb_bilerp({ v[5], v[6], v[7], v[8] }, x_step, y_step),
  }, z_step)
end

local x, y, z = 0.5, 0.5, 0.5 -- step values for each axis, might add per axis skew correction later
local verts = find_verts(M.hex2rgb({ arg[1], arg[2] }))
-- stylua: ignore
local result = M.rgb_trilerp({
  verts.rgb, verts.rgB, verts.rGb, verts.rGB,
  verts.Rgb, verts.RgB, verts.RGb, verts.RGB,
}, x, y, z)

local out_fmt = string.format('%s;%s;%s', math.floor(result.r), math.floor(result.g), math.floor(result.b))
local out_str = string.format('#%X%X%X', math.floor(result.r), math.floor(result.g), math.floor(result.b))
io.write(string.format('\x1b[48;2;%sm%s\x1b[m\n', out_fmt, out_str))

return M
