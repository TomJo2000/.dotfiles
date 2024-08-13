-- [[ Telescope ]]
local binds = require('plugins.telescope').binds
for _, v in pairs(binds) do
  local mode, lhs, rhs, opts = v[1], v[2], v[3], v[4]
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- [[ which-key ]]
require('which-key').register({
  ['<leader>c'] = { _ = 'which_key_ignore', name = '[C]ode' },
  ['<leader>d'] = { _ = 'which_key_ignore', name = '[D]ocument' },
  ['<leader>r'] = { _ = 'which_key_ignore', name = '[R]eplace' },
  ['<leader>s'] = { _ = 'which_key_ignore', name = '[S]earch' },
  ['<leader>w'] = { _ = 'which_key_ignore', name = '[W]orkspace' },
  ['<leader>l'] = { _ = 'which_key_ignore', name = '[L]ine numbers' },
  ['<leader>m'] = { _ = 'which_key_ignore', name = '[M]ini.map' },
  ['<leader>o'] = { _ = 'which_key_ignore', name = 'Split/Join [O]neliners' },
})

--[[ Hydra bindings ]]
require('plugins.hydra')
---@source autocmds.lua
require('posthoc.autocmds')
