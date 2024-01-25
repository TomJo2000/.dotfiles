---@see vim.g.clipboard :help clipboard-wsl
---| Translated from VimScript to Lua
vim.g.clipboard = {
  name = 'WslClipboard',
  cache_enabled = false,
  copy = { -- Copy works just fine
     ['+'] = 'clip.exe',
     ['*'] = 'clip.exe',
   },
  paste = { -- Paste is horrendously slow, but it works.
     ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
     ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
},
}
