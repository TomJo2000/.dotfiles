#!/usr/bin/env lua
-- trilerp.lua

local M = {}

---@param hex string | number
---@return rgb
function M.hex2rgb(hex)
  hex = hex:gsub('^#', '')
  return {
    r = tonumber('0x' .. hex:sub(1, 2)),
    g = tonumber('0x' .. hex:sub(3, 4)),
    b = tonumber('0x' .. hex:sub(5, 6))
  }
end

local from = M.hex2rgb(arg[1] or '#191FED')
local to = M.hex2rgb(arg[2] or '#F3D05B')
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

---@alias rgb {r: integer, g: integer, b: integer}
---@param _from rgb    # *RGB tuple*
---@param _to   rgb    # *RGB tuple*
---@param step integer # *Step*
---@return rgb
function M.rgb_lerp(_from, _to, step)
  return {
    r = _from.r * (1 - step) + _to.r * step,
    g = _from.g * (1 - step) + _to.g * step,
    b = _from.b * (1 - step) + _to.b * step,
  }
end

function M.rgb_bilerp(v1, v2, v3, v4, x_step, y_step)
  return M.rgb_lerp(
    M.rgb_lerp(v1, v2, x_step),
    M.rgb_lerp(v3, v4, x_step),
    y_step
  )
end

function M.rgb_trilerp(v1, v2, v3, v4, v5, v6, v7, v8, x_step, y_step, z_step)
  return M.rgb_lerp(
    M.rgb_bilerp(v1, v2, v3, v4, x_step, y_step),
    M.rgb_bilerp(v5, v6, v7, v8, x_step, y_step),
    z_step
  )
end

local x, y, z = 0.5, 0.5, 0.5 -- step values for each axis, might add per axis skew correction later
local result = M.rgb_trilerp(verts.rgb, verts.rgB, verts.rGb, verts.rGB, verts.Rgb, verts.RgB, verts.RGb, verts.RGB, x, y, z)

local out_fmt = string.format('%s;%s;%s', math.floor(result.r), math.floor(result.g), math.floor(result.b))
local out_str = string.format('#%X%X%X' , math.floor(result.r), math.floor(result.g), math.floor(result.b))
io.write(string.format('\x1b[48;2;%sm%s\x1b[m\n', out_fmt, out_str))

return M
