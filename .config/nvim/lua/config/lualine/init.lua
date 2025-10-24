-- (ACK) Based on:
-- Eviline config for lualine
-- Credit: glepnir
-- Author: shadmansaleh

local theme = require('onedark.colors')

local conditions = {
  ---@return boolean
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  ---@return boolean
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  ---@return boolean
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local custom = {
  -- buffers = require('plugins.lualine.buffers'),
  filename = require('config.lualine.filename'),
  lsp = require('config.lualine.lsp'),
  treesitter = require('config.lualine.treesitter'),
}

-- Config
local config = {
  options = {
    theme = 'onedark',
    always_divide_middle = false,
    globalstatus = true, -- one statusline to rule them all.
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
      return '' .. (vim.fn.mode()):upper()
    end,
    color = function()
      -- auto change color according to neovims mode
      -- stylua: ignore
      local mode_color = {
             n = theme.green,  -- Normal mode
            no = theme.red,    -- Normal mode (operator pending)
          [''] = theme.blue,   -- ???
             i = theme.red,    -- Insert mode
            ic = theme.yellow, -- Insert mode (completion)
             v = theme.blue,   -- Visual mode
             V = theme.blue,   -- Visual line mode
             R = theme.purple, -- Replace mode
            Rv = theme.purple, -- Replace mode (virtual)
             s = theme.orange, -- Select mode (charwise)
             S = theme.orange, -- Select mode (linewise)
             c = theme.purple, -- Command mode
            ce = theme.red,    -- ???
            cv = theme.red,    -- Ex mode
             t = theme.red,    -- Terminal mode
         ['!'] = theme.red,    -- External command is executing
        ['r?'] = theme.cyan,   -- Confirmation
             r = theme.purple, -- Hit Enter
            rm = theme.cyan,   -- -- more -- prompt
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
      if #buf_list > 1 then -- if we have multiple buffers find the number of buffers and the index of the current one
        local current_buf = vim.api.nvim_get_current_buf()
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
      -- no need for a buffer count on a single buffer
      return ' '
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
  { -- Insert mid section.
    '%=',
  },
  { -- Treesitter parser
    custom.treesitter.status,
    color = custom.treesitter.color,
  },
  { -- Lsp server name.
    custom.lsp.status,
    color = custom.lsp.color,
  },
}

-- Add components to right sections
focused.right = {
  { -- search count with working total
    function()
      local count = vim.fn.searchcount({ maxcount = 0 })
      return count.incomplete > 0 and '?/?' -- unfinished search
        or count.total > 0 and ('%s/%s'):format(count.current, count.total) -- has results
        or ''
    end,
    timeout = 500,
    color = { fg = theme.yellow },
    padding = { right = 1 },
  },
  { -- LSP diagnostics count
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = '', warn = '', info = '' },
    on_click = function(count, button, mods)
      local _ = count -- ignored
      local _ = mods -- ignored
      if button == 'l' then
        vim.diagnostic.setloclist({})
      end
    end,
    diagnostics_color = {
      color_error = { fg = theme.red },
      color_warn = { fg = theme.yellow },
      color_info = { fg = theme.cyan },
    },
    padding = { right = 1 },
  },
  { -- Showcmd
    function()
      return ('%s'):format(vim.api.nvim_eval_statusline('%S', {}).str)
    end,
    color = { fg = theme.diff_text },
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
    '%=',
  },
  { -- Treesitter parser
    custom.treesitter.status,
    color = custom.treesitter.color,
  },
  { -- Lsp server name.
    custom.lsp.status,
    color = custom.lsp.color,
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
      color_correction = 'static',
    },
    { -- If there is nothing after the navic module the background color doesn't work on it.
      -- I don't know why, and I frankly don't care.
      '%=',
    },
  },
}

config.sections.lualine_c = focused.left
config.sections.lualine_x = focused.right
config.inactive_sections.lualine_c = unfocused.left
config.inactive_sections.lualine_x = unfocused.right
config.winbar = winbar

return config
