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
require('config.treesitter')

-- [[ Delimiter colorization ]]
vim.g.rainbow_delimiters = require('config.delims')

-- [[ Comments ]]
vim.g.skip_ts_context_commentstring_module = true
require('ts_context_commentstring').setup({ enable_autocmd = false })
-- stylua: ignore
require('Comment').setup({
  padding   = true,
  sticky    = true,
  mappings  = { basic = true, extra = true },
  toggler   = { line  = '<leader>cc', block = '<leader>bb' },
  opleader  = { line  = '<leader>c' , block = '<leader>b'  },
  extra     = { above = '<leader>cO', below = '<leader>co'  , eol = '<leader>cA' },
  pre_hook  = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  post_hook = nil,
  ignore    = nil,
})

-- [[ Configure LSPs ]]
require('config.lsp')

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip').config.setup()
require('config.cmp')
