M = {}

local get_icon_and_color = require('nvim-web-devicons').get_icon_color_by_filetype

M.status = function()
  local buf_ft = vim.bo[0].ft
  -- vim.treesitter.highlighter is a private part of the API
  -- Not happy about using it here.
  local ts_highlighting = vim.treesitter.highlighter.active[vim.fn.bufnr()]
  local ts_parser = vim.treesitter.get_parser():lang()
  local ft_icon, _ = get_icon_and_color(buf_ft)
  local ret = ('%s %s'):format(ft_icon and ft_icon .. ' ' or '', buf_ft)
  if ts_highlighting ~= nil then
    local parser_info = vim.treesitter.language.inspect(ts_parser)
    -- Starting at ABI version 15 TS parsers include version metadata
    -- Display it if available.
    local parser_version = ''
    if parser_info.abi_version > 14 then
      parser_version = ('(%d:%d.%d.%d)'):format(
        parser_info.abi_version,
        parser_info.metadata.major_version or '?',
        parser_info.metadata.minor_version or '?',
        parser_info.metadata.patch_version or '?'
      )
    end
    ret = ('%s %s%s'):format(ft_icon or '', ts_parser, parser_version)
  end
  return ret
end

M.color = function()
  -- auto change color according to the filetype
  local _, ft_color = get_icon_and_color(vim.bo[0].ft)
  return { fg = ft_color or '#FFFFFF', gui = 'bold' }
end

return M
