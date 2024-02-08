-- document existing key chains
return require('which-key').register({
  ['<leader>c']  = { _ = 'which_key_ignore', name = '[C]ode' },
  ['<leader>d']  = { _ = 'which_key_ignore', name = '[D]ocument' },
  ['<leader>g']  = { _ = 'which_key_ignore', name = '[G]it' },
  ['<leader>gh'] = { _ = 'which_key_ignore', name = '[G]it [h]unks' },
  ['<leader>r']  = { _ = 'which_key_ignore', name = '[R]eplace' },
  ['<leader>s']  = { _ = 'which_key_ignore', name = '[S]earch' },
  ['<leader>w']  = { _ = 'which_key_ignore', name = '[W]orkspace' },
  -- my key chains
  ['<leader>l']  = { _ = 'which_key_ignore', name = '[L]ine numbers' },
  ['<leader>m']  = { _ = 'which_key_ignore', name = '[M]ini.map' },
  ['<leader>o']  = { _ = 'which_key_ignore', name = 'Split/Join [O]neliners' },
})

