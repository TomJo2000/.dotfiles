local mp = require('mp')

-- Auto-show history if mpv starts with no files
if mp.get_property_native('idle-active') then
  mp.add_timeout(0.1, function()
    mp.command('script-binding select/select-watch-history')
  end)
end
