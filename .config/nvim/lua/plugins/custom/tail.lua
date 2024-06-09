---Follow an updating buffer, like `tail -f`
return function()
  local MiniMap = package.loaded['mini.map'] or nil
  if MiniMap ~= nil then
    MiniMap.close()
  end

  vim.bo.autoread = true
  vim.bo.readonly = true
  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = 0,
    desc = 'Follow an updating buffer, like `tail -f`',
    callback = function()
      vim.cmd('checktime')
      vim.cmd([[call feedkeys('G')]])
    end,
  })
end
