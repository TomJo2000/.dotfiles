-- A Hydra for common Git operations

local hint = [[
 _<Down>_: next hunk   _s_: stage hunk      _d_: show deleted _b_: blame line
   _<Up>_: prev hunk   _S_: stage buffer    _h_: preview hunk _B_: blame show full
      _f_: file search _u_: undo last stage _v_: select hunk  _t_: toggle inline blame
      _q_: exit        _U_: unstage buffer  ^                 ^
]]

local GitSigns = package.loaded['gitsigns'] or {}

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
      vim.schedule(function() GitSigns.nav_hunk('next', { target = 'all' }) end)
      return '<Ignore>'
    end, { expr = true, desc = 'next hunk' }
    },
    { '<Up>', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() GitSigns.nav_hunk('prev', { target = 'all' }) end)
        return '<Ignore>'
      end, { expr = true, desc = 'prev hunk' }
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
    { 'U', function()
      local filename = vim.api.nvim_buf_get_name(0)
      vim.fn.system({ 'git', 'restore', '--staged', filename })
      end, { desc = '[U]nstage buffer' },
    },
    { 'v', GitSigns.select_hunk,                   { desc = '[v]isually select hunk' } },
    { 'q', nil,                                    { exit = true, nowait = true, desc = '[q]uit Git Hydra' } },
  },
  config = {
    color = 'pink',
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
    end,
    on_exit = function()
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd.loadview()
      vim.api.nvim_win_set_cursor(0, cursor_pos)
      vim.cmd.normal('zv')
    end,
  },
}
