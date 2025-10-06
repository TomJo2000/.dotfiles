local M = {}

---@see settings
---|https://luals.github.io/wiki/settings/
M.settings = {
  Lua = {
    completion = {
      displayContext = 5,
      keywordSnippet = 'Both', -- show keyword and snippet in suggestion
      callSnippet = 'Both', -- show function name and snippet in suggestion
      postfix = ' ', -- character to trigger postfix snippets
    },
    format = { enable = false }, -- I prefer using Stylua for formatting
    hint = {
      enable = true,
      setType = true,
      arrayIndex = 'Enable',
    },
    -- Make the server aware of Neovim runtime files
    ---@see workspace = { checkThirdParty = false },
    workspace = {
      checkThirdParty = false,
      -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
      -- library = {
      --   vim.api.nvim_get_runtime_file('', true),
      --   vim.env.VIMRUNTIME,
      --   "${3rd}/luv/library"
      --   "${3rd}/busted/library",
      -- },
      diagnostics = { disable = { 'duplicate-doc-alias' } },
    },
    hover = { enumsLimit = 50 },
    runtime = { version = 'LuaJIT' },
  },
}

return M
