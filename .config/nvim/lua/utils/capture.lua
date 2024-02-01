local util = {}

--- capture output from an external command
---@alias fmt_func fun(capture: string): any # gets passed the captured string
---@param cmd string|string[]                # command, either as a table of, or single string
---@param fmt (boolean|fmt_func)? # How should the output be formatted?
---*false*    -> return the raw capture
---*true|nil* -> default formatting
---*fmt_func* -> custom formatting
---@return string|fmt_func # return either a string or fmt(capture)
function util.capture(cmd, fmt)
  if type(cmd) == 'table' then
    cmd = unpack(cmd)
  end
  local shell   = assert(io.popen(cmd, 'r'), 'Failed to run: ' .. cmd)
  local capture = assert(shell:read('*a'), 'Could not capture: ' .. cmd)
  shell:close()
  if fmt == false then return capture end

  if type(fmt) == 'function' then
    capture = fmt(capture)
  else
    capture = capture:gsub('^%s+', ''):gsub('%s+$', ''):gsub('[\n\r]+', ' ')
  end
  return capture
end

return util

