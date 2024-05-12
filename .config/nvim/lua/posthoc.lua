require('editorconfig')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Treesitter ]]
---@source ./lua/config/treesitter.lua
require('plugins.treesitter').setup({
      -- stylua: ignore
    ensure_installed = {
      'bash', 'c', 'cpp', 'diff', 'go', 'git_config', 'git_rebase',
      'gitcommit', 'gitignore', 'html', 'just', 'ini', 'lua', 'python', 'regex',
      'rust', 'ssh_config', 'toml', 'typescript', 'vimdoc', 'vim', 'yaml'
    },
})

-- [[ Delimiter colorization ]]
vim.g.rainbow_delimiters = require('plugins.delims')

-- [[ open MiniMap ]]
require('mini.map').open()

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

-- [[ Comments ]]
vim.g.skip_ts_context_commentstring_module = true
require('ts_context_commentstring').setup({ enable_autocmd = false })

-- stylua: ignore
require('Comment').setup({
  padding   = true,
  sticky    = true,
  mappings  = { basic = true, extra = true },
  opleader  = { line  = '<leader>c' , block = '<leader>b'  },
  toggler   = { line  = '<leader>cc', block = '<leader>bb' },
  extra     = { above = '<leader>cO', below = '<leader>co'  , eol = '<leader>cA' },
  pre_hook  = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  post_hook = nil,
  ignore    = nil,
})

-- [[ Configure LSPs ]]
require('plugins.lsp')

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip').config.setup()
require('plugins.cmp')

--[[ Hydra bindings ]]
require('plugins.hydra')

vim.api.nvim_create_user_command('Format', function()
  require('conform').format({}, nil)
end, {})
