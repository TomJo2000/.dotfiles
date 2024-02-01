#!/usr/bin/env lua
-- trilerp.lua

---@class _trilerp
---@field [hex2rgb] function
---@field [trilerp] function
---@field [bilerp]  function
---@field [lerp]    function
local M = {}

---@alias rgb {r: integer, g: integer, b: integer}
---@param hex (string|number)?
---@return rgb
---@alias hex2rgb fun(hex): rgb
function M.hex2rgb(hex)
  assert(hex ~= nil, "Can't convert a nil value to RGB")
  hex = hex:gsub('^#', '')
  if #hex == 3 then
    local r, g, b = hex:match('(.)(.)(.)')
    hex = r:rep(2) .. g:rep(2) .. b:rep(2)
  end
  assert(hex:match('%x*'):len() == 6, "invalid hex: " .. hex)
  local r, g, b = hex:match('(..)(..)(..)')
  return {
    r = tonumber('0x' .. r),
    g = tonumber('0x' .. g),
    b = tonumber('0x' .. b),
  }
end

local from  = M.hex2rgb(arg[2] or '#191FED')
local to    = M.hex2rgb(arg[4] or '#F3D05B')

---@type { min: rgb, max: rgb, r: integer, g: integer, b: integer }
local diffs = { -- diffs, min and max per channel
  min = {
    r = math.min(from.r, to.r),
    g = math.min(from.g, to.g),
    b = math.min(from.b, to.b),
  },
  max = {
    r = math.max(from.r, to.r),
    g = math.max(from.g, to.g),
    b = math.max(from.b, to.b),
  },
  r = math.abs(from.r - to.r),
  g = math.abs(from.g - to.g),
  b = math.abs(from.b - to.b),
}

---@type { [string]: rgb }
local verts = { -- vertices
  ['rgb'] = { r = diffs.min.r, g = diffs.min.g, b = diffs.min.b },
  ['rgB'] = { r = diffs.min.r, g = diffs.min.g, b = diffs.max.b },
  ['rGb'] = { r = diffs.min.r, g = diffs.max.g, b = diffs.min.b },
  ['rGB'] = { r = diffs.min.r, g = diffs.max.g, b = diffs.max.b },
  ['Rgb'] = { r = diffs.max.r, g = diffs.min.g, b = diffs.min.b },
  ['RgB'] = { r = diffs.max.r, g = diffs.min.g, b = diffs.max.b },
  ['RGb'] = { r = diffs.max.r, g = diffs.max.g, b = diffs.min.b },
  ['RGB'] = { r = diffs.max.r, g = diffs.max.g, b = diffs.max.b },
}

---@alias lerp fun(_from, _to, float): rgb
---@param lerp rgb[]    # *2 RGB tuple*
---@param step float  # *Step*
---@return rgb
function M.rgb_lerp(lerp, step)
  return {
    r = lerp[1].r * (1 - step) + lerp[2].r * step,
    g = lerp[1].g * (1 - step) + lerp[2].g * step,
    b = lerp[1].b * (1 - step) + lerp[2].b * step,
  }
end

---@alias bilerp table<lerp, lerp, float, float>
---@param v      rgb[] # 4 elements
---@param x_step float # x-axis correction factor
---@param y_step float # y-axis correction factor
---@return rgb         # {r, g, b}:int
function M.rgb_bilerp(v, x_step, y_step)
  return M.rgb_lerp({
    M.rgb_lerp({ v[1], v[2] }, x_step),
    M.rgb_lerp({ v[3], v[4] }, x_step),
  }, y_step
  )
end

---@alias trilerp table<bilerp, bilerp, float, float, float>
---@param v      rgb[] # 8 elements
---@param x_step float # x-axis correction factor
---@param y_step float # y-axis correction factors
---@param z_step float # z-axis correction factors
---@return rgb         # {r, g, b}: int
function M.rgb_trilerp(v, x_step, y_step, z_step)
  return M.rgb_lerp({
    M.rgb_bilerp({ v[1], v[2], v[3], v[4] }, x_step, y_step),
    M.rgb_bilerp({ v[5], v[6], v[7], v[8] }, x_step, y_step),
  }, z_step
  )
end

local x, y, z = 0.5, 0.5, 0.5 -- step values for each axis, might add per axis skew correction later
local result = M.rgb_trilerp({
  verts.rgb, verts.rgB, verts.rGb, verts.rGB,
  verts.Rgb, verts.RgB, verts.RGb, verts.RGB,
}, x, y, z
)

local out_fmt = string.format('%s;%s;%s', math.floor(result.r), math.floor(result.g), math.floor(result.b))
local out_str = string.format('#%X%X%X', math.floor(result.r), math.floor(result.g), math.floor(result.b))
io.write(string.format('\x1b[48;2;%sm%s\x1b[m\n', out_fmt, out_str))

return M
