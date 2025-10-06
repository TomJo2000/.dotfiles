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

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.keymap.set('n', 'q', '<CMD>q<CR>', { desc = '[Q]uit' })
  end,
})

vim.api.nvim_create_autocmd('ModeChanged', {
  once = true,
  pattern = 'n:*', -- Normal to any
  callback = function()
    vim.keymap.del('n', 'q')
  end,
})

-- vim.api.nvim_create_autocmd('WinResized', {
--   callback = function()
--     -- adjust minimap width
--   end,
--   group = 'MiniMap',
-- })

-- Make `help` and `man` buffers open to the right (used HJKL for arg)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'man' },
  command = 'wincmd L',
})

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

vim.api.nvim_create_autocmd('BufEnter', {
  -- group = 'Title',
  pattern = '*',
  callback = function()
    ---returns *`git_root`* or `nil` if not in a git repository
    ---@param file string|number
    ---@return string git_root
    local function isGit(file)
      return vim.fs.root(file, '.git') or ''
    end
    ---returns *`num`* directory components
    ---@param self string
    ---@param num integer
    ---@return string
    local function split_dir(self, num)
      return self:match(('[^/]*'):rep(num, '/') .. '$')
    end
    local netrw = vim.fn.getbufvar('%', 'netrw_curdir') ---@type string
    local bufname = vim.api.nvim_buf_get_name(0)
    local stack = vim.fn.gettagstack(0)
    local name = {
      help = stack.length > 0 and (':h %s'):format((stack.items[stack.length].tagname):match('[^@]*')),
      man = bufname,
      netrw = split_dir(netrw:gsub(isGit(netrw), ''), 3) or split_dir(bufname, 3),
      ['*'] = split_dir(bufname, 2),
    }
    return name[vim.o.ft] or name['*']
  end,
})

-- See `:h ++p`
-- Automatically create directories before saving a file
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    local file_path = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(file_path) == 0 then
      vim.fn.mkdir(file_path, 'p')
    end
  end,
})

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
