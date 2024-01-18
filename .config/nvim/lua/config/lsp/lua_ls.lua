---@return table Lua_ls_config
return {
  Lua = {
    runtime = {
      -- Tell the language server which version of Lua you're using
      -- (most likely LuaJIT in the case of Neovim)
      version = 'LuaJIT'
    },
    -- Make the server aware of Neovim runtime files
    ---@see workspace = { checkThirdParty = false },
    workspace = {
      checkThirdParty = false,
      library = {
        vim.env.VIMRUNTIME
        -- "${3rd}/luv/library"
        -- "${3rd}/busted/library",
      }
      ---@see telemetry = { enable = false },
      ---@see NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      ---@see diagnostics = { disable = { 'missing-fields' } },
      -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
      -- library = vim.api.nvim_get_runtime_file("", true)
    },
  },
}
