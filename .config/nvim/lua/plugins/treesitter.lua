-- See `:h nvim-treesitter`
local M = {}

M.ts = {
  auto_install = true,
  -- stylua: ignore
  ensure_installed = {
    'bash', 'c', 'cpp', 'diff', 'go', 'git_config', 'git_rebase',
    'gitcommit', 'gitignore', 'html', 'json', 'json5', 'jsonc',
    'just', 'ini', 'lua', 'printf', 'python', 'regex', 'rust',
    'ssh_config', 'tmux', 'toml', 'typescript', 'vim', 'vimdoc',
    'xml', 'yaml'
  },
}

M.context = {
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  zindex = 20, -- The Z-index of the context window
  max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

return M
