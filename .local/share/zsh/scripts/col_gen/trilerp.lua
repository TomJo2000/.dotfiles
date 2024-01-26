#!/usr/bin/env lua
-- trilerp.lua

local f = { r = 25, g = 31, b = 237 }  -- from #191FED
local t = { r = 243, g = 208, b = 91 } -- to   #F3D05B
local d = {                            -- diffs, min and max per channel
  r = math.abs(f.r - t.r),
  g = math.abs(f.g - t.g),
  b = math.abs(f.b - t.b),
  min = {
    r = math.min(f.r, t.r),
    g = math.min(f.g, t.g),
    b = math.min(f.b, t.b),
  },
  max = {
    r = math.max(f.r, t.r),
    g = math.max(f.g, t.g),
    b = math.max(f.b, t.b),
  }
}

local v = { -- vertices
  ['rgb'] = { r = d.min.r, g = d.min.g, b = d.min.b },
  ['rgB'] = { r = d.min.r, g = d.min.g, b = d.max.b },
  ['rGb'] = { r = d.min.r, g = d.max.g, b = d.min.b },
  ['rGB'] = { r = d.min.r, g = d.max.g, b = d.max.b },
  ['Rgb'] = { r = d.max.r, g = d.min.g, b = d.min.b },
  ['RgB'] = { r = d.max.r, g = d.min.g, b = d.max.b },
  ['RGb'] = { r = d.max.r, g = d.max.g, b = d.min.b },
  ['RGB'] = { r = d.max.r, g = d.max.g, b = d.max.b },
}

---@alias rgb {r: integer, g: integer, b: integer}
---@param from  rgb   # RGB tuple
---@param to    rgb       # RGB tuple
---@param step integer # Step
---@return rgb
local function rgb_lerp(from, to, step)
  return {
    r = from.r * (1 - step) + to.r * step,
    g = from.g * (1 - step) + to.g * step,
    b = from.b * (1 - step) + to.b * step,
  }
end

local function rgb_bilerp(v1, v2, v3, v4, x, y)
  return rgb_lerp(
    rgb_lerp(v1, v2, x),
    rgb_lerp(v3, v4, x),
    y
  )
end

local function rgb_trilerp(v1, v2, v3, v4, v5, v6, v7, v8, x, y, z)
  return rgb_lerp(
    rgb_bilerp(v1, v2, v3, v4, x, y),
    rgb_bilerp(v5, v6, v7, v8, x, y),
    z
  )
end

local result = rgb_trilerp(v.rgb, v.rgB, v.rGb, v.rGB, v.Rgb, v.RgB, v.RGb, v.RGB, 0.5, 0.5, 0.5)
local out_str = string.format('%s;%s;%s', math.floor(result.r), math.floor(result.g), math.floor(result.b))
io.write(string.format('\x1b[38;2;%sm%s\x1b[m\n', out_str, out_str))

