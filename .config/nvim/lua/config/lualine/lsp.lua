local M = {}

local get_icon_and_color = require('nvim-web-devicons').get_icon_color_by_filetype

M.status = function()
  local clients, ret, lsp_version = vim.lsp.get_clients({ bufnr = 0 }), '', nil

  for _, client in ipairs(clients) do
    if vim.tbl_contains(client.config['filetypes'], vim.bo[0].ft) then
      lsp_version = ('(%s)'):format(vim.tbl_get(client, 'server_info', 'version'))
      ret = ('%s%s%s'):format(ret .. ', ', client.name, lsp_version)
    end
  end

  return ret ~= '' and ('/%s '):format(ret:sub(3)) or ''
end

M.color = function()
  -- auto change color according to the filetype
  local _, ft_color = get_icon_and_color(vim.bo[0].ft)
  return { fg = ft_color or '#FFFFFF', gui = 'bold' }
end

return M
