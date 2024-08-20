-- See `:h vim.highlight.on_yank()`
--[[ Highlight on yank ]]
local hl_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = hl_group,
  pattern = '*',
})

vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*:c', -- any to command
  callback = function()
    vim.o.hlsearch = true
  end,
})

vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = 'c:*', -- command to any
  callback = function()
    vim.o.hlsearch = false
  end,
})

-- vim.api.nvim_create_autocmd('WinResized', {
--   callback = function()
--     -- adjust minimap width
--   end,
--   group = 'MiniMap',
-- })

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local close_map = {
      help = true,
      lazy = true,
      man = true,
    }
    require('mini.map')[close_map[vim.bo.filetype] and 'close' or 'open']()
  end,
  group = 'MiniMap',
  pattern = '*',
})

-- See `:h ++p`
--[[ Create missing directories ]]
-- vim.api.nvim_create_autocmd({ 'BufWritePre', 'FileWritePre' }, {
--   callback = function()
--     local buf_file = vim.fn.getbufinfo()[vim.fn.bufnr('%')].name
--     local parent_dir = vim.fs.dirname(buf_file)
--     -- This handles URLs using netrw. See ':help netrw-transparent' for details.
--     if parent_dir:find('%l+://') == 1 then
--       return
--     end
--
--     if vim.fn.isdirectory(parent_dir) == 0 then
--       vim.fn.mkdir(parent_dir, 'p')
--     end
--   end,
--   pattern = '*',
-- })

-- [[ Ex commands ]]

-- :Tail
local tail = require('plugins.custom.tail')
-- partially based on: https://unix.stackexchange.com/a/417939
vim.api.nvim_create_user_command('Tail', tail, {})

-- :Format
vim.api.nvim_create_user_command('Format', function()
  require('conform').format({}, nil)
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd.normal('gg=G')
  vim.api.nvim_win_set_cursor(0, pos)
end, {})
