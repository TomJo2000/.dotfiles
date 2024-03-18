-- A Hydra for common Git operations

local hint = [[
 _<Down>_: next hunk     _s_: stage hunk        _d_: show deleted   _b_: blame line
 _<Up>_: prev hunk     _u_: undo last stage   _h_: preview hunk   _B_: blame show full
 _v_: select hunk   _S_: stage buffer      _f_: file search    _t_: toggle inline blame
 _/_: show base file ^ ^ ^ ^ _q_: exit
]]

local gitsigns = require('gitsigns')

return {
  name = 'Git',
  mode = { 'n', 'x' },
  hint = hint,
  config = {
    buffer = true,
    color = 'pink',
    invoke_on_body = true,
    hint = {
      border = 'rounded',
    },
    on_enter = function()
      vim.cmd('mkview')
      vim.cmd('silent! %foldopen!')
      vim.bo.modifiable = false
      -- gitsigns.toggle_signs(true)
      -- gitsigns.toggle_linehl(true)
    end,
    on_exit = function()
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd('loadview')
      vim.api.nvim_win_set_cursor(0, cursor_pos)
      vim.cmd('normal zv')
      -- gitsigns.toggle_signs(false)
      -- gitsigns.toggle_linehl(false)
      -- gitsigns.toggle_deleted(false)
    end,
  },
  body = '<leader>g',
  -- stylua: ignore
  heads = {
    { '<Down>', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gitsigns.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = 'next hunk' }
    },
    { '<Up>', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gitsigns.prev_hunk() end)
        return '<Ignore>'
      end,
      { expr = true, desc = 'prev hunk' }
    },
    { 'B', function()
      gitsigns.blame_line({ full = true })
    end, { desc = '[B]lame show full' }
    },
    { 'b', gitsigns.blame_line,                    { desc = '[b]lame' } },
    { 'd', gitsigns.toggle_deleted,                { nowait = true, desc = 'toggle [d]eleted' } },
    { 'f', require('telescope.builtin').git_files, { desc = '[G]it [F]ile search' } },
    { 'h', gitsigns.preview_hunk,                  { desc = 'preview [h]unk' } },
    { 's', gitsigns.stage_hunk,                    { desc = '[s]tage hunk' } },
    { 'S', gitsigns.stage_buffer,                  { desc = '[S]tage buffer' } },
    { 't', gitsigns.toggle_current_line_blame,     { desc = '[t]oggle inline git blame' } },
    { 'u', gitsigns.undo_stage_hunk,               { desc = '[u]ndo last stage' } },
    { 'v', gitsigns.select_hunk,                   { desc = '[v]isually select hunk' } },
    { '/', gitsigns.show,                          { exit = true, desc = '[/] show base file' } },
    { 'q', nil,                                    { exit = true, nowait = true, desc = '[q]uit Git Hydra' } },
  },
}
