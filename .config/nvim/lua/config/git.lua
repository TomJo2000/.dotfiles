local capture = require('utils').capture
capture('git -p status -v')

vim.o.splitright = vim.o.splitright or true
vim.cmd.vnew()
vim.wo.signcolumn = 'no'
vim.wo.number = false
vim.wo.relativenumber = false

