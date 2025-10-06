-- A Hydra for interactive rename/replace operations
return {
  name = 'Replace',
  mode = { 'n', 'v' },
  -- hint = [[ ]],
  config = {
    buffer = true,
    color = 'teal',
    invoke_on_body = true,
  },
  body = '<leader>r',
  ---@type { head: string, cmd:string|function, opts: table? }[]
  heads = {
    { 'n', vim.lsp.buf.rename, { desc = '[R]e[n]ame' } },
  },
}
