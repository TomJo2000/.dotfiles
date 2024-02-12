---@see navic-config
return {
  -- stylua: ignore
  icons = {
    File        = '󰈙', Module        = '', Namespace = '󰌗', Package  = '',
    Class       = '󰌗', Method        = '󰆧', Property  = '', Field    = '',
    Constructor = '', Enum          = '󰕘', Interface = '󰕘', Function = '󰊕',
    Variable    = '󰆧', Constant      = '󰏿', String    = '󰀬', Number   = '󰎠',
    Boolean     = '◩', Array         = '󰅪', Object    = '󰅩', Key      = '󰌋',
    Null        = '󰟢', EnumMember    = '', Struct    = '󰌗', Event    = '',
    Operator    = '󰆕', TypeParameter = '󰊄',
  },
  lsp = {
    auto_attach = true,
    preference = { 'lua_ls', 'bashls' },
  },
  highlight = false,
  separator = '❯',
  depth_limit = 0,
  depth_limit_indicator = '…',
  safe_output = true,
  lazy_update_context = false,
  click = true,
  format_text = function(text)
    return text
  end,
}
