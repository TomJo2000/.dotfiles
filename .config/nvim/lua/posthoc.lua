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
-- This function gets run when an LSP connects to a particular buffer.
-- local on_attach = function(_, bufnr) end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable LSPs
---| Lua_ls
---| Bashls
---@source ./config/lsp/init.lua
local servers = require('config.lsp')

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup({
      capabilities = capabilities,
      --    on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    })
  end,
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip').config.setup()
require('config.cmp')
