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

mp.observe_property('pause', 'bool', function(_, paused)
  mp.add_timeout(0.1, function()
    if paused then
      ov:update()
    else
      ov:remove()
    end
  end)
end)
