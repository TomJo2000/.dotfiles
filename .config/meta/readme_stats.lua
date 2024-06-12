#!/usr/bin/env luajit

---@alias fmt_func fun(capture: string): any # gets passed the captured string
---@param cmd string|string[]                # command, either as a table of, or single string
---@param fmt (boolean|fmt_func)? # How should the output be formatted?
---*false*    -> return the raw capture
---*true|nil* -> default formatting
---*fmt_func* -> custom formatting
---@return string|fmt_func # return either a string or fmt(capture)
local function capture(cmd, fmt)
  if type(cmd) == 'table' then
    cmd = unpack(cmd)
  end
  local shell = assert(io.popen(cmd, 'r'), 'Failed to run: ' .. cmd)
  local output = assert(shell:read('*a'), 'Could not capture: ' .. cmd)
  shell:close()

  if fmt == false then
    return capture
  elseif type(fmt) == 'function' then
    capture = fmt(output)
  else -- fmt == nil
    return output
    -- output = output:gsub('^%s+', ''):gsub('%s+$', ''):gsub('[\n\r]+', ' ')
  end
  return output
end

local git_root = capture('git -C ' .. os.getenv('PWD') .. ' rev-parse --show-toplevel')
  or capture('git -C ' .. os.getenv('DOT_FILES') .. ' rev-parse --show-toplevel')

-- stylua: ignore
local csv = capture({ [[scc]]
  .. [[ --no-cocomo]] .. [[ --no-complexity]]      -- Don't give me the COCOMO crap
  .. [[ --exclude-file]] .. [[ .gitignore]]        -- Respect the ignores in .gitignore
  .. [[ --sort]] .. [[ code]]                      -- sort by lines of code
  .. [[ --size-unit]] .. [[ binary]]               -- use binary size
  .. [[ --format]] .. [[ csv]]                     -- output as CSV
  .. [[ --remap-all '# shellcheck shell=':Shell,]] -- [Remap] Shellchek shell directives -> Shell
  .. [['#!/usr/bin/env bash':Shell,]]              -- Bash -> Shell
  .. [['# -*- desktopfile -*-':'Desktop file',]]   -- Desktop files and related
  .. [['# -*- gitconfig -*-':'Git config',]]       -- Git config and related
  .. [['# -*- sshconfig -*-':'SSH config',]]       -- SSH config
  .. [['# -*- service -*-':'Systemd Service',]]    -- Systemd service files
  .. [['# -*- ini -*-':INI,]]                      -- INI and related
  .. [[ -- ]] .. git_root --[[@as string]]         -- Search directory
})

-- Based on the parser from:
-- http://lua-users.org/wiki/LuaCsv
local function csv2table(line, sep)
  local T = {}
  local pos = 1
  sep = sep or ','
  while true do
    local char = string.sub(line, pos, pos)
    if char == '' then
      break
    elseif char == '"' then
      -- quoted value (ignore separator within)
      local str = ''
      repeat
        local from, to = string.find(line, '^%b""', pos)
        str = str .. string.sub(line, from + 1, to - 1)
        pos = to + 1
        char = string.sub(line, pos, pos)
        if char == '"' then
          str = str .. '"'
        end
      -- check first char AFTER quoted string, if it is another
      -- quoted string without separator, then append it
      -- this is the way to "escape" the quote char in a quote. example:
      --   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
      until char ~= '"'
      table.insert(T, str)
      assert(char == sep or char == '')
      pos = pos + 1
    else
      -- no quotes used, just look for the first separator
      local from, to = string.find(line, sep, pos)
      if from then
        table.insert(T, string.sub(line, pos, from - 1))
        pos = to + 1
      else
        -- no separator found -> use rest of string and terminate
        table.insert(T, string.sub(line, pos))
        break
      end
    end
  end
  return T
end

local function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

print(csv)
dump(csv2table(csv))
