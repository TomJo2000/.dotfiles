local capture = require('utils').capture
vim.o.splitright = vim.o.splitright or true
-- vim.cmd.vnew()
vim.wo.signcolumn = 'no'
vim.wo.number = false
vim.wo.relativenumber = false

  -- .. '| set nonu nornu signcolumn=no '
local git_staged ='terminal { git -c color.ui=always status'
  .. '; git -P diff --staged --shortstat'
  .. '; git -P diff --staged; } '
  .. '| delta --paging=never'

vim.cmd.vnew(git_staged)
