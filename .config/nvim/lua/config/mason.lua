--- LSPs and related tooling that should be present.
---@alias mason_package string
---@alias executable string
---@type { [mason_package]: executable }
local servers = {
  -- Bash
  ['bash-language-server'] = 'bash-language-server',
  ['shellcheck'] = 'shellcheck',
  ['shellharden'] = 'shellharden',
  -- C/C++
  ['clangd'] = 'clangd',
  -- GitHub Actions
  ['actionlint'] = 'actionlint',
  ['gh-actions-language-server'] = 'gh-actions-language-server',
  -- Golang
  ['gopls'] = 'gopls',
  -- HTML
  ['html-lsp'] = 'vscode-html-language-server',
  -- JQ
  ['jq-lsp'] = 'jq-lsp',
  -- JSON
  ['json-lsp'] = 'vscode-json-language-server',
  -- Just
  ['just-lsp'] = 'just-lsp',
  -- Lua
  ['lua-language-server'] = 'lua-language-server',
  ['stylua'] = 'stylua',
  -- Markdown
  ['marksman'] = 'marksman',
  -- CMake
  ['neocmakelsp'] = 'neocmakelsp',
  -- Spellchecking
  ['codespell'] = 'codespell',
  -- Systemd services
  ['systemd-lsp'] = 'systemd-lsp',
  -- Termux build scripts
  ['termux-language-server'] = 'termux-language-server',
  -- TOML
  ['taplo'] = 'taplo',
  -- Treesitter Queries
  ['ts_query_ls'] = 'ts_query_ls',
  -- Zig
  ['zls'] = 'zls',
}

local registry = require('mason-registry')
registry.refresh(function()
  --- List of `servers` that are outdated or not installed
  ---@type table<mason_package?>
  local missing_or_outdated = vim.tbl_values(
    -- What LSPs that we want are not currently available?
    ---@param pkg mason_package
    ---@return mason_package?
    vim.tbl_map(function(pkg)
      -- Report back any missing executables for checking with Mason.
      return vim.fn.executable(servers[pkg]) == 0 and pkg or nil
    end, vim.tbl_keys(servers))
  )

  -- Doesn't work with all LSPs on Termux, so don't use it on that.
  if not vim.fn.has('termux') and not vim.tbl_isempty(missing_or_outdated) then
    vim.cmd.MasonInstall(missing_or_outdated)
  end
end)

local lsp_config_mappings = require('mason-lspconfig').get_mappings().package_to_lspconfig
-- termux-language-server isn't known to this lookup table, so add it manually.
lsp_config_mappings['termux-language-server'] = 'termux_language_server'
---Mapping from enabled Mason packages to their `vim.lsp.config()` names
---@type string[]
return vim.tbl_values(
  -- get the set of lspconfig servers
  vim.tbl_map(function(lsp)
    return lsp_config_mappings[lsp]
  end, vim.tbl_keys(servers))
)
