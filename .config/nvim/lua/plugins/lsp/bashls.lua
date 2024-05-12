local M = {}

M.settings = {
  bashIde = {
    globPattern = '*@(.sh|.bash|.zsh|.inc|.command)',
  },
}

M.filetypes = { 'bash', 'sh', 'zsh' }

return M
