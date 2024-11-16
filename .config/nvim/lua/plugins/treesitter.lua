-- See `:h nvim-treesitter`
return {
  auto_install = true,

  -- stylua: ignore
  ensure_installed = {
    'bash', 'c', 'cmake', 'cpp', 'csv', 'desktop', 'diff', 'editorconfig',
    'go', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit',
    'gitignore', 'html', 'json', 'json5', 'jsonc', 'just', 'ini',
    'lua', 'luadoc', 'luap', 'make', 'markdown', 'markdown_inline',
    'passwd', 'printf', 'python', 'query', 'regex', 'rust', 'sql',
    'ssh_config', 'tmux', 'toml', 'typescript', 'vim', 'vimdoc',
    'xml', 'yaml', 'zig',
  },
  indent = {
    enable = true,
    disable = { 'just' },
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'zsh' },
  },
}
