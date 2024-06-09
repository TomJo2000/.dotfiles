local M = {}

M.filetypes = { 'bash', 'sh', 'zsh' }

M.settings = {
  bashIde = {
    globPattern = '*@(.sh|.bash|.zsh|.inc|.command)',
  },
}

return M
