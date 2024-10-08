-- See `:h nvim-treesitter`
return {
  auto_install = true,

  -- stylua: ignore
  ensure_installed = {
    'bash', 'c', 'cmake', 'cpp', 'diff', 'go', 'git_config',
    'git_rebase', 'gitcommit', 'gitignore', 'html', 'json',
    'json5', 'jsonc', 'just', 'ini', 'lua', 'make', 'printf',
    'python', 'query', 'regex', 'rust', 'ssh_config', 'tmux',
    'toml', 'typescript', 'vim', 'vimdoc', 'xml', 'yaml'
  },
}
