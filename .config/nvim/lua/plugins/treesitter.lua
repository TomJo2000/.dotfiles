local M = {}

local treesitter_dir = vim.fn.stdpath('data') .. '/treesitter'

-- See `:h nvim-treesitter`
M.ts = {
  indent = {
    enable = true,
    disable = { 'just' },
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'just', 'zsh' },
  },
  install_dir = treesitter_dir,
}

-- Automatic installation was removed from nvim-treesitter in commit:
-- https://github.com/nvim-treesitter/nvim-treesitter/commit/ab230eadd4a96baec86fb17bd625893649f2612f
-- Using https://github.com/lewis6991/ts-install.nvim to handle it instead.
M.install = {
  -- This automatically downloads missing parsers based on filetype
  -- I don't want it making a download outside of `:Lazy`.
  auto_install = false,
  -- Also only do this on `:Lazy update`
  auto_update = false,
  -- stylua: ignore
  ensure_install = {
    'bash', 'c', 'cmake', 'cpp', 'csv', 'desktop', 'diff', 'editorconfig',
    'go', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit',
    'gitignore', 'graphql', 'html', 'json', 'json5', 'jsonc', 'just',
    'kdl', 'ini', 'lua', 'luadoc', 'luap', 'make', 'markdown',
    'markdown_inline', 'passwd', 'printf', 'python', 'query', 'regex',
    'rust', 'sql', 'ssh_config', 'tmux', 'toml', 'typescript', 'vim',
    'vimdoc', 'xml', 'yaml', 'zig',
  },
  -- Ignore the parsers already provided by Neovim core.
  ignore_install = { 'c', 'lua', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
  install_dir = treesitter_dir,
}

return M
