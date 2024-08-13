local hint = [[

]]

return {
  name = 'Resize',
  mode = { 'n', 'v' },
  hint = hint,
  body = '<leader>W',
  -- stylua: ignore
  heads = {
    { '<Up>',    '<C-w>+', { desc = '↑' } },
    { '<Down>',  '<C-w>-', { desc = '↓' } },
    { '<Left>',  '<C-w><', { desc = '→' } },
    { '<Right>', '<C-w>>', { desc = '←' } },
  },
}
