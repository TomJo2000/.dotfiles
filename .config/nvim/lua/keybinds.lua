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
  { 'n', 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true } },
  { 'n', 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true } },

  -- Diagnostic keymaps
  { 'n', '[d'       , vim.diagnostic.goto_prev , { desc = 'Go to previous diagnostic message' } },
  { 'n', ']d'       , vim.diagnostic.goto_next , { desc = 'Go to next diagnostic message' }     },
  { 'n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' }  },
  { 'n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' }             },

  -- Miscellaneous
  { { 'n', 'v' }, '<Space>', '<Nop>'      , { silent = true }   },
  {   'n'       , '<C-s>'  , vim.cmd.write, { desc = '[S]ave' } },

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
}

for _, v in pairs(binds) do
  local mode, lhs, rhs, opts = v[1], v[2], v[3], v[4]
  vim.keymap.set(mode, lhs, rhs, opts)
end
