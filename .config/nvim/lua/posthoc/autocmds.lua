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
  -- defer turning off search highlights for a bit
  callback = function()
    vim.defer_fn(function()
      vim.o.hlsearch = false
    end, 500)
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

--- Based on:
---@source https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#marvinth01a
vim.api.nvim_create_autocmd('QuitPre', {
  callback = function()
    local tree_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match('NvimTree_') ~= nil then
        table.insert(tree_wins, w)
      end
      if vim.api.nvim_win_get_config(w).relative ~= '' then
        table.insert(floating_wins, w)
      end
    end
    if 1 == #wins - #floating_wins - #tree_wins then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(tree_wins) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
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
  vim.api.nvim_feedkeys('gg=G', 'n', true)
  vim.api.nvim_win_set_cursor(0, pos)
end, {})
