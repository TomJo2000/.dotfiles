-- [[ Telescope ]]
local binds = require('plugins.telescope').binds
for _, v in pairs(binds) do
  local mode, lhs, rhs, opts = v[1], v[2], v[3], v[4]
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- reset the "last search" register
-- I don't like it persisting between sessions
vim.fn.setreg('/', '')

--[[ Hydra bindings ]]
require('plugins.hydra')
---@source autocmds.lua
require('posthoc.autocmds')
