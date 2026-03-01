local theme = package.loaded['onedark.colors']

return {
  lualine_c = {
    { -- open buffers
      'buffers',
      icons_enabled = false,
      show_modified_status = false,
      fmt = function(str, context) -- icons always have a space by default, if we add them ourselves, we can change that.
        local icon, _ = require('nvim-web-devicons').get_icon(context.filetype)
        return ('%s%s'):format(icon or '', str)
      end,
      max_length = 0, -- Maximum width of buffers component,
      buffers_color = {
        active = { fg = theme.bg_blue, bg = theme.bg1 }, -- Color for active buffer.
        inactive = { fg = theme.grey, bg = theme.bg0 }, -- Color for inactive buffer.
      },
      filetype_names = {
        alpha = 'Alpha',
        fzf = 'FZF',
        TelescopePrompt = 'Telescope',
      },
      padding = {},
    },
    { -- Breadcrumbs
      'navic',
      color_correction = 'dynamic',
    },
    { -- If there is nothing after the navic module
      -- the background color doesn't work on the rest of the winbar.
      -- I don't know why, and I frankly don't care.
      '%=',
    },
  },
}
