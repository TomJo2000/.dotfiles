local capture = require('utils.capture')
vim.o.splitright = vim.o.splitright or true

vim.cmd.vnew()

-- stylua: ignore
vim.cmd.setlocal(
  'nonumber',
  'norelativenumber',
  'nosigncolumn',
  'buftype=nofile',
  'bufhidden=delete',
  'noswapfile'
)

vim.api.nvim_buf_set_name(0, '')
vim.cmd.normal('ggdG')

-- stylua: ignore
local staged = capture('{ git -c color.ui=always status'
            .. '; git -P diff --staged --shortstat'
            .. '; git -P diff --staged; }'
            .. '| delta --paging=never')
vim.api.nvim_put({
  staged --[[@as string]],
}, 'l', true, false)
