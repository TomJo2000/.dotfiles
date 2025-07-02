--- LSPs and related tooling to enable
---@type { [string]: string }
local servers = {
  -- Bash
  ['bash-language-server'] = 'bash-language-server',
  ['shellcheck'] = 'shellcheck',
  ['shellharden'] = 'shellharden',
  -- GitHub Actions
  ['gh-actions-language-server'] = 'gh-actions-language-server',
  -- HTML
  ['html-lsp'] = 'vscode-html-language-server',
  -- JSON
  ['json-lsp'] = 'vscode-json-language-server',
  -- Just
  ['just-lsp'] = 'just-lsp',
  -- Lua
  ['lua-language-server'] = 'lua-language-server',
  ['stylua'] = 'stylua',
  -- Markdown
  ['marksman'] = 'marksman',
  -- Spellchecking
  ['codespell'] = 'codespell',
  -- Systemd services
  ['systemd-language-server'] = 'systemd-language-server',
  -- Termux build scripts
  ['termux-language-server'] = 'termux-language-server',
  -- TOML
  ['taplo'] = 'taplo',
}

-- If we have any of these installed enable their LSP
vim.tbl_map(function(if_have)
  if vim.fn.executable(if_have['req']) == 1 then
    servers[if_have['pkg']] = if_have['bin'] or if_have['pkg']
  end
end, {
  { req = 'clang', pkg = 'clangd' },
  { req = 'go', pkg = 'gopls' },
  { req = 'jq', pkg = 'jq-lsp' },
  { req = 'zig', pkg = 'zls' },
})

require('mason-registry').refresh(function()
  --- List of `servers` that are not currently available
  ---@type string[]
  local need = vim.tbl_values(
    -- What LSPs that we want are not currently available?
    vim.tbl_map(function(pkg)
      -- vim.print(pkg, servers[pkg])
      return vim.fn.executable(servers[pkg]) == 0 and pkg or nil
    end, vim.tbl_keys(servers))
  )

  if not vim.tbl_isempty(need) then
    vim.cmd.MasonInstall(need)
  end
end)

local mappings = require('mason-lspconfig').get_mappings().package_to_lspconfig
---Mapping from enabled Mason packages to their `vim.lsp.config` namees
---@type string[]
local lspconfig_servers = vim.tbl_values(
  -- get the set of lspconfig servers
  vim.tbl_map(function(lsp)
    return mappings[lsp]
  end, vim.tbl_keys(servers))
)

vim.lsp.enable(lspconfig_servers)
