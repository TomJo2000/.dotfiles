-- A Hydra for common Git operations

local hint = [[
 _<Down>_: next hunk     _s_: stage hunk        _d_: show deleted   _b_: blame line
 _<Up>_: prev hunk     _u_: undo last stage   _h_: preview hunk   _B_: blame show full
 _v_: select hunk   _S_: stage buffer      _f_: file search    _t_: toggle inline blame
 _/_: show base file ^ ^ ^ ^ _q_: exit
]]

local GitSigns = package.loaded['gitsigns'] or nil

--- You're gonna need 'lewis6991/gitsigns.nvim', okay?
---@diagnostic disable: undefined-field, need-check-nil
return {
  name = 'Git',
  mode = { 'n', 'x' },
  hint = hint,
  body = '<leader>g',
  -- stylua: ignore
  heads = {
    { '<Down>', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() GitSigns.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = 'next hunk' }
    },
    { '<Up>', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() GitSigns.prev_hunk() end)
        return '<Ignore>'
      end,
      { expr = true, desc = 'prev hunk' }
    },
    { 'B', function()
      GitSigns.blame_line({ full = true })
    end, { desc = '[B]lame show full' }
    },
    { 'b', GitSigns.blame_line,                    { desc = '[b]lame' } },
    { 'd', GitSigns.toggle_deleted,                { nowait = true, desc = 'toggle [d]eleted' } },
    { 'f', require('telescope.builtin').git_files, { desc = '[G]it [F]ile search' } },
    { 'h', GitSigns.preview_hunk,                  { desc = 'preview [h]unk' } },
    { 's', GitSigns.stage_hunk,                    { desc = '[s]tage hunk' } },
    { 'S', GitSigns.stage_buffer,                  { desc = '[S]tage buffer' } },
    { 't', GitSigns.toggle_current_line_blame,     { desc = '[t]oggle inline git blame' } },
    { 'u', GitSigns.undo_stage_hunk,               { desc = '[u]ndo last stage' } },
    { 'v', GitSigns.select_hunk,                   { desc = '[v]isually select hunk' } },
    { '/', GitSigns.show,                          { exit = true, desc = '[/] show base file' } },
    { 'q', nil,                                    { exit = true, nowait = true, desc = '[q]uit Git Hydra' } },
  },
  config = {
    color = 'pink',
    invoke_on_body = true,
    buffer = true,
    hint = {
      border = 'rounded',
    },
    on_enter = function()
      vim.cmd.mkview()
      vim.cmd('silent! %foldopen!')
      vim.bo.modifiable = false
    end,
    on_exit = function()
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd.loadview()
      vim.api.nvim_win_set_cursor(0, cursor_pos)
      vim.cmd.normal('zv')
    end,
  },
}
