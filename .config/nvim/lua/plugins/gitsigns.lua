return {
  numhl = true,
  attach_to_untracked = true,
  -- stylua: ignore
  signs = {
    add          = { text = '' },
    change       = { text = '⦿' },
    delete       = { text = '' },
    topdelete    = { text = '' },
    changedelete = { text = '⦿' },
    untracked    = { text = '┇' },
  },
  -- stylua: ignore
  signs_staged = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    changedelete = { text = '┃' },
    delete       = { text = '┃' },
    topdelete    = { text = '┃' },
  },
  on_attach = function(bufnr)
    vim.keymap.set({ 'n', 'v' }, ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        package.loaded.gitsigns.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })

    vim.keymap.set({ 'n', 'v' }, '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        package.loaded.gitsigns.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
  end,
}
