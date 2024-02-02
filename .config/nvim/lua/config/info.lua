---@enum info
local M = {}
---@type fun():integer
 function M.height() return vim.o.lines end
---@type fun():integer
 function M.width() return vim.o.columns end
---@type fun():integer
 function M.status_line_height() return vim.o.cmdheight + 1 end
return M

