-- Setup LSP settings
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.lsp.config('*', {
      capabilities = {
        textDocument = {
          semanticTokens = {
            multilineTokenSupport = true,
          },
        },
      },
      root_markers = { '.git' },
    })

    vim.lsp.enable(require('config.mason'))
  end,
})

-- Taken from the example in `:h vim.lsp.foldexpr()`
-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end,
})
