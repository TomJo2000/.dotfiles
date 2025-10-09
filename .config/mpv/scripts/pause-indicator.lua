--[[ ACK: https://github.com/CogentRedTester/mpv-scripts
  Prints a pause icon in the middle of the screen when mpv is paused
]]

local mp = require('mp')
local ov = mp.create_osd_overlay('ass-events')
-- in Advanced SubStation - ASS format
-- http://www.tcax.org/docs/ass-specs.htm
-- stylua: ignore
ov.data = '{\\an5}'        .. -- Align, NUMPAD style, 5 is centered
          '{\\b1}'         .. -- Bold
          '{\\fs192}'      .. -- Font size, 192
          '{\\c&HFFFFFF&}' .. -- Color, #FFFFFF
          '⏸'                 -- Actual text

local paused, time = nil, nil
local function remove_on_frame_advance(_, pos)
  if paused and time and pos ~= time then
    ov:remove()
  end
  time = pos
end

-- Track pause state
mp.observe_property('pause', 'bool', function(_, state)
  paused = state
  if paused then
    ov:update()
  else
    ov:remove()
  end
end)

-- Detect frame advance while paused
mp.observe_property('time-pos', 'number', remove_on_frame_advance)
