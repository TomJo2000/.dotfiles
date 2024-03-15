-- Enable LSPs
---| Lua_ls
---| Bashls
---| Taplo (TOML)
---| Cspell (Spellchecker)
---| editorconfig-checker
local servers = {
  lsp = {
    ['lua_ls'] = require('config.lsp.lua_ls'),
    ['bashls'] = require('config.lsp.bashls'),
    ['taplo'] = require('config.lsp.taplo'),
  },
  linters = {
    -- ['cspell'] = require('config.lsp.cspell'),
    ['editorconfig-checker'] = require('config.lsp.ec-checker'),
  },
}

-- This function gets run when an LSP connects to a particular buffer.
-- local on_attach = function(_, bufnr) end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers.lsp),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    -- stylua: ignore
    require('lspconfig')[server_name].setup({
      capabilities = capabilities,
      settings     = servers.lsp[server_name].settings,
      on_attach    = servers.lsp[server_name].on_attach,
      filetypes    = (servers.lsp[server_name] or {}).filetypes,
    })
  end,
})

-- require('lint').linters_by_ft = {
--   _ = {},
-- }
