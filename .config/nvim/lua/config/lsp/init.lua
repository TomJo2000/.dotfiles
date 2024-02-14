return {
  ---@source ./lua_ls.lua
  lua_ls = require('config.lsp.lua_ls'),
  ---@source ./bashls.lua
  bashls = require('config.lsp.bashls'),
  ---@source ./gopls.lua
  -- gopls = require('config.lsp.gopls'),
  -- clangd = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
}

