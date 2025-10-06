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
