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
  on_attach = function(bufnr)
    -- don't override the built-in and fugitive keymaps
    local gs = package.loaded.gitsigns

    vim.keymap.set({ 'n', 'v' }, ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })

    vim.keymap.set({ 'n', 'v' }, '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })

  end,
}
