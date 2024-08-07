-- (ACK) Based on:
-- Eviline config for lualine
-- Credit: glepnir
-- Author: shadmansaleh

-- Color table for highlights
local theme = require('plugins.onedark').colors

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

local custom = {
  -- buffers = require('plugins.lualine.buffers'),
  filename = require('plugins.lualine.filename'),
}

-- Config
local config = {
  options = {
    theme = 'onedark',
    always_divide_middle = false,
    component_separators = '',
    section_separators = '',
    icons_enabled = true,
    padding = { left = 0, right = 0 },
    refresh = { statusline = 150, tabline = 150, winbar = 150 },
    disabled_filetypes = { -- Filetypes to disable lualine for.
      statusline = {}, -- only ignores the ft for statusline.
      winbar = {}, -- only ignores the ft for winbar.
    },
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
    winbar = {},
  },
  -- stylua: ignore
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {}, lualine_b = {}, lualine_c = {},
    lualine_x = {}, lualine_y = {}, lualine_z = {},
  },
}

local focused = {}

-- Add components to left sections
focused.left = {
  { -- Left edge
    function()
      return '▊'
    end,
    color = { fg = theme.blue }, -- Sets highlighting of component
    padding = { right = 1 }, -- We don't need space before this
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
             c = theme.purple, -- Command mode
            ce = theme.red,     -- ???
            cv = theme.red,     -- Ex mode
             t = theme.red,     -- Terminal mode
         ['!'] = theme.red,     -- External command is executing
        ['r?'] = theme.cyan,    -- Confirmation
             r = theme.purple,  -- Hit Enter
            rm = theme.cyan,    -- -- more -- prompt
      }
      return { fg = mode_color[vim.fn.mode()] }
    end,
    padding = { right = 1 },
  },
  { -- File size (also controls save indicator)
    'filesize',
    cond = conditions.buffer_not_empty,
    color = { fg = theme.cyan },
    padding = {},
  },
  { -- Show order and number of open buffers
    function()
      local buf_list = vim.fn.getbufinfo({ buflisted = 1 })
      if #buf_list == 1 then -- no need for a buffer count on a single buffer
        return ' '
      else -- if we have multiple buffers find the number of buffers and the index of the current one
        local current_buf = vim.fn.bufnr('%')
        local index
        -- Find what index in the buffer list is the current buffer
        for i = 1, #buf_list do
          if buf_list[i].bufnr == current_buf then
            index = i
            break
          end
        end
        -- return out the index and total number of buffers
        return (' ❮%s/%s❯ '):format(index, #buf_list)
      end
    end,
    color = { fg = theme.orange },
    padding = {},
  },
  { -- File name, with changed formatting
    custom.filename,
    color = { fg = theme.green },
    padding = { right = 1 },
  },
  { -- combined location and progress component
    function()
      return ('%d:%d┇%d%%%%'):format(
        vim.fn.line('.'), -- current line
        vim.fn.virtcol('.'), -- current column
        math.floor(100 * vim.fn.line('.') / vim.fn.line('$')) -- percentage into the file
      )
    end,
    color = { fg = theme.bg_blue, gui = 'bold' },
    padding = {},
  },
  { -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater than 2
    function()
      return '%='
    end,
  },
  { -- Lsp server name.
    function()
      local msg = 'No Active Lsp'
      local buf_ft
      local clients
      buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
      clients = vim.lsp.get_clients()

      if next(clients) == nil then
        return msg
      end
      for _, client in ipairs(clients) do
        local filetypes = client.config['filetypes']
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
focused.right = {
  { -- LSP diagnostics count
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = '', warn = '', info = '' },
    diagnostics_color = {
      color_error = { fg = theme.red },
      color_warn = { fg = theme.yellow },
      color_info = { fg = theme.cyan },
    },
    padding = { right = 1 },
  },
  { -- Unicode codepoint in Hex.
    function()
      return ('U+%04X'):format(vim.api.nvim_eval_statusline('%b', {}).str)
    end, -- tests: 2 digit µ, 3 digit ඞ, 4 digit , 5 digit 󰕰
    color = { fg = theme.cyan },
  },
  { -- File encoding
    'o:encoding',
    fmt = string.upper,
    cond = conditions.hide_in_width,
    color = { fg = theme.green, gui = 'bold' },
    padding = { left = 1 },
  },
  { -- Line endings
    'fileformat',
    fmt = string.upper,
    color = { fg = theme.green, gui = 'bold' },
  },
  { -- Git branch
    'branch',
    icon = '',
    color = { fg = theme.purple, gui = 'bold' },
    padding = { left = 1 },
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
    padding = { left = 1 },
  },
  { -- Right edge
    function()
      return '▊'
    end,
    color = { fg = theme.blue },
    padding = { left = 1 },
  },
}

local unfocused = {}

unfocused.left = {
  { -- File size (also controls save indicator)
    'filesize',
    cond = conditions.buffer_not_empty,
    color = { fg = theme.cyan },
    padding = { right = 1 },
  },
  { -- File name, with changed formatting
    custom.filename,
    color = { fg = theme.green },
    padding = { right = 1 },
  },
  { -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater than 2
    function()
      return '%='
    end,
  },
  { -- Lsp server name.
    function()
      local msg = 'No Active Lsp'
      local buf_ft
      local clients
      buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
      clients = vim.lsp.get_clients()
      if next(clients) == nil then
        return msg
      end
      for _, client in ipairs(clients) do
        local filetypes = client.config['filetypes']
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

unfocused.right = {
  { -- Git diff
    'diff',
    symbols = { added = '', modified = '󰓢', removed = '' },
    diff_color = {
      added = { fg = theme.green },
      modified = { fg = theme.orange },
      removed = { fg = theme.red },
    },
    cond = conditions.hide_in_width,
    padding = { left = 1 },
  },
}

local winbar = {
  lualine_c = {
    { -- open buffers
      'buffers',
      max_length = 0, -- Maximum width of buffers component,
      show_modified_status = false, -- Shows indicator when the buffer is modified.
      symbols = {
        modified = '', -- Text to show when the buffer is modified
        alternate_file = '#', -- Text to show to identify the alternate file
        directory = '', -- Text to show when the buffer is a directory
      },
      buffers_color = {
        -- Same values as the general color option can be used here.
        active = { fg = theme.bg_blue, bg = theme.bg1 }, -- Color for active buffer.
        inactive = { fg = theme.grey, bg = theme.bg0 }, -- Color for inactive buffer.
      },
      filetype_names = {
        alpha = 'Alpha',
        fzf = 'FZF',
        TelescopePrompt = 'Telescope',
      }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
    },
    { -- Breadcrumbs
      'navic',
      color_correction = nil,
      navic_opts = nil,
      color = { bg = theme.bg0 },
    },
    { -- Insert mid section. You can make any number of sections in neovim :)
      -- for lualine it's any number greater than 2
      function()
        return '%='
      end,
    },
  },
}

config.sections.lualine_c = focused.left
config.sections.lualine_x = focused.right
config.inactive_sections.lualine_c = unfocused.left
config.inactive_sections.lualine_x = unfocused.right
config.winbar = winbar

return config
