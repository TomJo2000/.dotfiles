local hint = [[
_<Esc>_: quit
%{up}
_<Left>_^ ↑ ^_<Up>_
%{left} ← ^ ^ → %{right}
_<Down>_^ ↓ ^_<Right>_
%{down}
]]

--- Returns true if *find* is contained in *tbl*
---@param find any
---@param tbl table
---@return boolean
local function find_val(find, tbl)
  for _, val in pairs(tbl) do
    if val == find then
      return true
    elseif type(val) == 'table' then
      if find_val(find, val) == true then
        return true
      end
    end
  end
  return false
end

return {
  name = 'Resize',
  mode = { 'n', 'v' },
  hint = hint,
  body = '<leader>W',
  -- stylua: ignore
  heads = {
    { '<Up>',    '<C-w>-', { desc = '↑' } },
    { '<Down>',  '<C-w>+', { desc = '↓' } },
    { '<Left>',  '<C-w><', { desc = '→' } },
    { '<Right>', '<C-w>>', { desc = '←' } },
  },
  config = {
    exit = false, -- I guess this would be a purple hydra?
    foreign_keys = nil, -- repeat on head, but quit on non head.
    invoke_on_body = true,
    hint = {
      ---@see api-win_config
      float_opts = {
        style = 'minimal',
        border = 'single',
        focusable = false,
        noautocmd = true,
      },
      funcs = {
        up = function()
          return ('%8s'):format(vim.fn.winheight(0))
        end,
        down = function()
          local hsplit = find_val('col', vim.fn.winlayout())
          local height = vim.fn.winheight(0)
          return (hsplit or height ~= vim.o.lines - 3) and ('%8s'):format(vim.o.lines - height - (hsplit and 4 or 2)) or ''
        end,
        left = function() -- working
          local width = vim.fn.winwidth(0)
          return ('%4s'):format(vim.o.columns == width and width or width - 1)
        end,
        right = function()
          local vsplit = find_val('row', vim.fn.winlayout())
          local width = vim.fn.winwidth(0)
          return (vsplit and width < vim.o.columns) and ('%s'):format(vim.o.columns - vim.fn.winwidth(0) - 1) or ''
        end,
      },
    },
  },
}
