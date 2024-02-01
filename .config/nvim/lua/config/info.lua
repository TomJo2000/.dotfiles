---@enum info
return {
  ---@return integer # total height of the window in lines
  height             = function() return vim.o.lines end,
  ---@return integer # total width of the window in columns
  width              = function() return vim.o.columns end,
  ---@return integer # height of the command and status line
  status_line_height = function() return vim.o.cmdheight + 1 end,
}

