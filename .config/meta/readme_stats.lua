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
  local shell  = assert(io.popen(cmd, 'r'), 'Failed to run: '     .. cmd)
  local output = assert(shell:read('*a')  , 'Could not capture: ' .. cmd)
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

print(
  capture({ [[scc ]]
    .. [[--no-cocomo]] .. [[ --no-complexity]]      -- Don't give me the COCOMO crap
    .. [[ --exclude-file]] .. [[ .gitignore ]]      -- Respect the ignores in .gitignore
    .. [[--sort]] .. [[ code]]                      -- sort by lines of code
    .. [[ --size-unit]] .. [[ binary]]              -- use binary size
    .. [[ --format]] .. [[ csv ]]                   -- output as CSV
    .. [[--remap-all '# shellcheck shell=':Shell,]] -- [Remap] Shellchek shell directives -> Shell
    .. [['#!/usr/bin/env bash':Shell,]]             -- Bash -> Shell
    .. [['# -*- desktopfile -*-':'Desktop file',]]  -- Desktop files and related
    .. [['# -*- gitconfig -*-':'Git config',]]      -- Git config and related
    .. [['# -*- sshconfig -*-':'SSH config',]]      -- SSH config
    .. [['# -*- service -*-':'Systemd Service',]]   -- Systemd service files
    .. [['# -*- ini -*-':INI,]]                     -- INI and related
    .. [[ -- ]] .. git_root --[[@as string]]        -- Search directory
    })
)

