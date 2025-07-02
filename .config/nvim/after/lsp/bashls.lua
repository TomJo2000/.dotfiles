local M = {}

M.filetypes = { 'bash', 'sh', 'zsh' }

---@see config.ts
---|https://github.com/bash-lsp/bash-language-server/blob/main/server/src/config.ts
M.settings = {
  bashIde = {
    globPattern = '**/*@(.sh|.bash|.zsh|.inc|.command)',
  },
}

return M
