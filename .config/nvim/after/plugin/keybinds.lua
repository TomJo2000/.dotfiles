-- [[ Basic keybinds ]]
-- stylua: ignore
local binds = {
  -- Moving lines
  { 'n', '<M-Down>'  , 'ddp' , { desc = 'Swap line down' }       },
  { 'n', '<M-Up>'    , 'ddkP', { desc = 'Swap line up' }         },
  { 'n', '<M-C-Down>', 'yyp' , { desc = 'Copy line below' }      },
  { 'n', '<M-C-Up>'  , 'yyP' , { desc = 'Copy line above' }      },
  { 'v', '<M-Down>'  , 'yjp' , { desc = 'Copy selection below' } },
  { 'v', '<M-Up>'    , 'ykp' , { desc = 'Copy selection above' } },

  -- Switching buffers
  { 'n', '<C-b>'  , vim.cmd.bprevious, { desc = 'Buffer [b]efore' } },
  { 'n', '<C-n>'  , vim.cmd.bnext    , { desc = '[N]ext buffer' }   },
  { 'n', '<M-C-b>', vim.cmd.bfirst   , { desc = 'First buffer' }    },
  { 'n', '<M-C-n>', vim.cmd.blast    , { desc = 'Last buffer' }     },

  -- dealing with line wrapping
  { { 'n', 'v' } , 'k'     , [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true } },
  { { 'n', 'v' } , 'j'     , [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true } },
  { { 'n', 'v' } , '<Up>'  , [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true } },
  { { 'n', 'v' } , '<Down>', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true } },
  { 'i', '<Up>'  , [[v:count == 0 ? '<C-o>gk' : '<C-o>k']], { expr = true, silent = true } },
  { 'i', '<Down>', [[v:count == 0 ? '<C-o>gj' : '<C-o>j']], { expr = true, silent = true } },

  -- Diagnostic keymaps
  { 'n', '<S-Up>'   , function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Go to previous diagnostic message' } },
  { 'n', '<S-Down>' , function() vim.diagnostic.jump({ count =  1, float = true }) end, { desc = 'Go to next diagnostic message' }     },
  { 'n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' } },
  { 'n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' }            },

  -- Miscellaneous
  { { 'n', 'v' }, '<Space>', '<Nop>'      , { silent = true }   },
  { 'n'         , '<C-s>'  , vim.cmd.write, { desc = '[S]ave' } },

  --[[ Line numbers ]]
  { { 'n', 'v' }, '<leader>ll', function()
      local state = vim.o.number
      vim.o.number = not state
      vim.o.relativenumber = state
    end, { desc = 'toggle [l]ine number mode' },
  },

  { { 'n', 'v' }, '<leader>la', function()
      vim.o.number = not vim.o.number
    end, { desc = 'toggle [a]bsolute line numbers' },
  },

  { { 'n', 'v' }, '<leader>lr', function()
      vim.o.relativenumber = not vim.o.relativenumber
    end, { desc = 'toggle [r]elative line numbers' },
  },

  { { 'n', 'v' }, '<leader>lh', function()
      local state = not vim.o.relativenumber
      vim.o.number = state
      vim.o.relativenumber = state
    end, { desc = 'toggle [h]ybrid line numbers' },
  },

  { 'n', '<leader>tf', require('plugins.custom.tail'), { desc = '`[t]ail -[f] <buf>`' } },
  { 'n', '<C-.>.', function()
    vim.notify( ('U+%04X'):format(vim.api.nvim_eval_statusline('%S', {}).str), vim.log.levels.WARN, {ttl=30} )
  end, { desc = 'amongus' } },

  { { 'n', 'v' }, '<C-CR>', function() vim.cmd.normal('o') end, { desc='Insert newline below'} },
  { { 'n', 'v' }, '<S-C-CR>', function() vim.cmd.normal('O') end, { desc= 'Insert newline above' } },
}

vim.tbl_map(function(bind)
  vim.keymap.set(unpack(bind))
end, binds)
