-- A Hydra for interactive rename/replace operations
---@return table hydra # A Replacer hydra
return {
  name = 'Replace',
  -- hint = [[ ]],
  config = {
    buffer = bufnr,
    color  = 'red',

  },
  mode = 'n',
  body = '<leader>r',
  ---@type { head: string, cmd:string|function, desc: table? }[]
  heads = {
    { 'n', vim.lsp.buf.rename, { desc = '[R]e[n]ame' } },
    { 'r', function()
      local col  = vim.api.nvim_win_get_cursor(0)[2] + 1
      local char = vim.api.nvim_get_current_line():sub(col, col)

    end, { desc = '[r]replace in line' } },
    { 'R', '<cmd><cr>',        { desc = '[S]ave' } },
  },
}
