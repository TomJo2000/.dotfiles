return {
  filters = {
    git_ignored = false,
    custom = {
      '^\\.git',
    },
  },
  disable_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    width = function()
      return math.floor(0.175 * vim.o.columns)
    end,
    preserve_window_proportions = true,
  },
  renderer = {
    add_trailing = true,
    root_folder_label = false,
    highlight_git = true,
    indent_markers = { enable = true },
    icons = {
      glyphs = {
        default = '󰈚',
        folder = {
          default = '',
          empty = '',
          empty_open = '',
          open = '',
          symlink = '',
        },
        git = {
          unstaged = '',
          staged = '󰸞',
          unmerged = '',
          renamed = '󰫍',
          untracked = '󰏢',
          deleted = '',
          ignored = '◌',
        },
      },
    },
  },
}
