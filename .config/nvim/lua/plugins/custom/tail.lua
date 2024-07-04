---Follow an updating buffer, like `tail -f`
return function(opts)
  local MiniMap = package.loaded['mini.map'] or nil
  if type(opts) ~= 'table' then
    ---@diagnostic disable-next-line: redefined-local, unused-local
    local opts = { opts }
  end
  local update_time = opts.update_time or '50'
  -- stylua: ignore
  vim.cmd.setlocal(
    'autoread',
    'readonly',
    'updatetime=' .. update_time
  )

  if MiniMap ~= nil then
    MiniMap.close()
  end

  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = 0,
    desc = 'Follow an updating buffer, like `tail -f`',
    callback = function()
      vim.cmd.checktime()
      vim.api.nvim_feedkeys('G', 'n', true)
    end,
  })
end
