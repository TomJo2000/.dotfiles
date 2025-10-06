--- LSPs and related tooling to enable
---@type { [string]: string }
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
  ['systemd-language-server'] = 'systemd-language-server',
  -- Termux build scripts
  ['termux-language-server'] = 'termux-language-server',
  -- TOML
  ['taplo'] = 'taplo',
  -- Zig
  ['zls'] = 'zls',
}

require('mason-registry').refresh(function()
  --- List of `servers` that are not currently available
  ---@type string[]
  local want = vim.tbl_values(
    -- What LSPs that we want are not currently available?
    vim.tbl_map(function(pkg)
      -- vim.print(pkg, servers[pkg])
      return vim.fn.executable(servers[pkg]) == 0 and pkg or nil
    end, vim.tbl_keys(servers))
  )

  if not vim.tbl_isempty(want) then
    vim.cmd.MasonInstall(want)
  end
end)

local mappings = require('mason-lspconfig').get_mappings().package_to_lspconfig
---Mapping from enabled Mason packages to their `vim.lsp.config` namees
---@type string[]
local lsp_configs = vim.tbl_values(
  -- get the set of lspconfig servers
  vim.tbl_map(function(lsp)
    return mappings[lsp]
  end, vim.tbl_keys(servers))
)

return lsp_configs
