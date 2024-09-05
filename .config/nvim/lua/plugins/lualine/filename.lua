return function()
  local options = {
    ---@param ft string
    ---@return string symbol
    read_only = function(ft)
      local symbol = { help = '', man = '', ['*'] = '' }
      return symbol[ft] or symbol['*']
    end,
    modified = '⦿',
    max_len = vim.fn.winwidth(0) / 3,
  }

  local function check_git_workspace()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end

  ---@param ft string
  ---@return string? name
  local function file_name(ft)
    ---returns *`git_root`* or `nil` if not in a git repository
    ---@param file string|number
    ---@return string git_root
    local function isGit(file)
      return vim.fs.root(file, '.git') or ''
    end
    ---returns *`num`* directory components
    ---@param self string
    ---@param num integer
    ---@return string
    local function split_dir(self, num)
      return self:match(('[^/]*'):rep(num, '/') .. '$')
    end
    local netrw = vim.fn.getbufvar('%', 'netrw_curdir') ---@type string
    local bufname = vim.api.nvim_buf_get_name(0)
    local stack = vim.fn.gettagstack(0)
    local name = {
      help = stack.length > 0 and (':h %s'):format((stack.items[stack.length].tagname):match('[^@]*')),
      man = bufname,
      netrw = split_dir(netrw:gsub(isGit(netrw), ''), 3) or split_dir(bufname, 3),
      ['*'] = split_dir(bufname, 2),
    }
    return name[ft] or name['*']
  end

  return ('%s%s%s'):format(
    vim.bo.modifiable and '' or options.read_only(vim.bo.filetype), -- readonly?
    file_name(vim.bo.filetype) or '[nofile]', -- get the display string for the name
    vim.bo.modified and options.modified or '' -- unsaved changes?
  )
end
