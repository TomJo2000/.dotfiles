local hint = [[
_<Left>_^ ↑ ^_<Up>_
^ ^ ^ ^ ^ ^← ^ ^ →
_<Down>_^ ↓ ^_<Right>_
]]

return {
  name = 'Resize',
  mode = { 'n', 'v' },
  hint = hint,
  body = '<leader>W',
  -- stylua: ignore
  heads = {
    { '<Up>',    '<C-w>-', { desc = '↑' } },
    { '<Down>',  '<C-w>+', { desc = '↓' } },
    { '<Left>',  '<C-w>>', { desc = '→' } },
    { '<Right>', '<C-w><', { desc = '←' } },
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
    },
    on_enter = function()
      vim.cmd.mkview()
      vim.cmd('silent! %foldopen!')
      vim.bo.modifiable = false
      -- lualine = package.loaded['lualine']
      -- conf = lualine.get_config()
      -- local conf = vim.tbl_deep_extend('force', conf, )
    end,
    on_exit = function()
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd.loadview()
      vim.api.nvim_win_set_cursor(0, cursor_pos)
      vim.cmd.normal('zv')
    end,
  },
}
