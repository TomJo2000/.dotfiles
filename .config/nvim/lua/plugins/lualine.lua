-- (ACK) Based on:
-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir

-- Color table for highlights
local theme = require('config.colors')

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = 'onedark',
    -- We are going to use lualine_c and lualine_x as left and
    -- right section. Both are highlighted by c theme .  So we
    -- are just setting default looks to statusline
    -- normal = { c = { fg = theme.fg, bg = theme.bg0 } },
    -- inactive = { c = { fg = theme.fg, bg = theme.bg0 } },
  },
  -- stylua: ignore
  sections = {
    -- these are to remove the defaults
    lualine_a = {}, lualine_b = {},
    lualine_y = {}, lualine_z = {},
    -- These will be filled later
    lualine_c = {}, lualine_x = {},
  },
  -- stylua: ignore
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {}, lualine_b = {}, lualine_c = {},
    lualine_x = {}, lualine_y = {}, lualine_z = {},
  },
}

-- Add components to left sections
config.sections.lualine_c = {
  { -- Left edge
    function()
      return '▊'
    end,
    color = { fg = theme.blue }, -- Sets highlighting of component
    padding = { left = 0, right = 1 }, -- We don't need space before this
  },
  { -- Vim mode indicator
    function()
      return ''
    end,
    color = function()
      -- auto change color according to neovims mode
      -- stylua: ignore
      local mode_color = {
             n = theme.green,   -- Normal mode
            no = theme.red,     -- Normal mode (operator pending)
          [''] = theme.blue,    -- ???
             i = theme.red,     -- Insert mode
            ic = theme.yellow,  -- Insert mode (completion)
             v = theme.blue,    -- Visual mode
             V = theme.blue,    -- Visual line mode
             R = theme.purple,  -- Replace mode
            Rv = theme.purple,  -- Replace mode (virtual)
             s = theme.orange,  -- Select mode (charwise)
             S = theme.orange,  -- Select mode (linewise)
             c = theme.dark_purple, -- Command mode
            ce = theme.red,     -- ???
            cv = theme.red,     -- Ex mode
             t = theme.red,     -- Terminal mode
         ['!'] = theme.red,     -- External command is executing
        ['r?'] = theme.cyan,    -- Confirmation
             r = theme.purple,  -- Hit Enter
            rm = theme.cyan,    -- -- more -- prompt
          [''] = theme.orange,  -- ???
      }
      return { fg = mode_color[vim.fn.mode()] }
    end,
    padding = { right = 1 },
  },
  { -- File size (also controls save indicator)
    'filesize',
    cond = conditions.buffer_not_empty,
  },
  { -- File name
    'filename',
    cond = conditions.buffer_not_empty,
    color = { fg = theme.purple, gui = 'bold' },
  },
  { -- Line:Column
    'location',
  },
  { -- Percentage into the file
    'progress',
    color = { fg = theme.fg, gui = 'bold' },
  },
  { -- LSP diagnostics count
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
    diagnostics_color = {
      color_error = { fg = theme.red },
      color_warn = { fg = theme.yellow },
      color_info = { fg = theme.cyan },
    },
  },
  { -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    function()
      return '%='
    end,
  },
  { -- Lsp server name.
    function()
      local msg = 'No Active Lsp'
      local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
      local clients = vim.lsp.get_active_clients()
      if next(clients) == nil then
        return msg
      end
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          return client.name
        end
      end
      return msg
    end,
    icon = ' LSP:',
    color = { fg = '#ffffff', gui = 'bold' },
  },
}

-- Add components to right sections
config.sections.lualine_x = {
  { -- File encoding
    'o:encoding', -- option component same as &encoding in viml
    fmt = string.upper, -- I'm not sure why it's upper case either ;)
    cond = conditions.hide_in_width,
    color = { fg = theme.green, gui = 'bold' },
  },
  { -- Line endings
    'fileformat',
    fmt = string.upper,
    icons_enabled = true,
    color = { fg = theme.green, gui = 'bold' },
  },
  { -- Git branch
    'branch',
    icon = '',
    color = { fg = theme.purple, gui = 'bold' },
  },
  { -- Git diff
    'diff',
    symbols = { added = '', modified = '󰓢', removed = '' },
    diff_color = {
      added = { fg = theme.green },
      modified = { fg = theme.orange },
      removed = { fg = theme.red },
    },
    cond = conditions.hide_in_width,
  },
  { -- Right edge
    function()
      return '▊'
    end,
    color = { fg = theme.blue },
    padding = { left = 1 },
  },
}
-- Now don't forget to initialize lualine
return config
