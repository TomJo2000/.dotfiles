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

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip').config.setup()
require('plugins.cmp')

--[[ Hydra bindings ]]
require('plugins.hydra')

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
--[[  ]]
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
