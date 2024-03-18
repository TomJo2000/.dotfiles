local M = {}

M.filetypes = 'lua'

M.settings = {
  Lua = {
    completion = {
      displayContext = 5,
      keywordSnippet = 'Both',
      postfix = ' ',
    },
    format = { enable = false }, -- I prefer using Stylua for formatting
    hint = {
      enable = true,
      arrayIndex = 'Enable',
      setType = true,
    },
    hover = { enumsLimit = 50 },
    runtime = { version = 'LuaJIT' },
    -- Make the server aware of Neovim runtime files
    ---@see workspace = { checkThirdParty = false },
    workspace = {
      checkThirdParty = false,
      library = {
        vim.env.VIMRUNTIME,
        -- "${3rd}/luv/library"
        -- "${3rd}/busted/library",
      },
      ---@see NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      ---@see diagnostics = { disable = { 'missing-fields' } },
      -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
      -- library = vim.api.nvim_get_runtime_file("", true)
    },
  },
}

M.on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navbuddy').attach(client, bufnr)
  end
end

return M
