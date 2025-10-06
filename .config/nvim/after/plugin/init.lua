-- [[ Telescope ]]
vim.tbl_map(function(bind)
  vim.keymap.set(unpack(bind))
end, require('plugins.telescope').binds)

-- reset the "last search" register
-- I don't like it persisting between sessions
vim.fn.setreg('/', '')

vim.diagnostic.config({ update_in_insert = true })

--[[ Hydra bindings ]]
require('config.hydra')
