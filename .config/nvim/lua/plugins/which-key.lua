local M = {}

M.opts = {
  spec = {
    -- prefixes
    -- stylua: ignore
    { mode = 'n',
      { '<leader>c', group = 'Code Actions'     , desc = '[C]ode'                 },
      { '<leader>d', group = 'Document Actions' , desc = '[D]ocument'             },
      { '<leader>r', group = 'Replace'          , desc = '[R]eplace'              },
      { '<leader>s', group = 'Searching'        , desc = '[S]earch'               },
      { '<leader>w', group = 'Workspace Actions', desc = '[W]orkspace'            },
      { '<leader>l', group = 'Lines'            , desc = '[L]ine numbers'         },
      { '<leader>m', group = 'Mini'             , desc = '[M]ini.map'             },
      { '<leader>o', group = 'Splitjoin'        , desc = 'Split/Join [O]neliners' },
    },

    -- stylua: ignore
    { --[[ Moving lines ]]
      { mode = 'n',
        { '<M-Down>'  , 'ddp' , desc = 'Swap line down'  },
        { '<M-Up>'    , 'ddkP', desc = 'Swap line up'    },
        { '<M-C-Down>', 'yyp' , desc = 'Copy line below' },
        { '<M-C-Up>'  , 'yyP' , desc = 'Copy line above' },
        --[[ dealing with line wrapping ]]
        { expr = true, silent = true,
          { 'j', [[v:count == 0 ? 'gj' : 'j']] },
          { 'k', [[v:count == 0 ? 'gk' : 'k']] },
        },
      },
      { mode = 'v',
        { '<M-Down>', 'yjp', desc = 'Copy selection below' },
        { '<M-Up>'  , 'ykp', desc = 'Copy selection above' },
      },
      group = 'movement',
    },

    --[[ Switching buffers ]]
    -- stylua: ignore
    { mode = 'n',
      { '<C-b>'  , vim.cmd.bprevious, desc = 'Buffer [b]efore' },
      { '<C-n>'  , vim.cmd.bnext    , desc = '[N]ext buffer'   },
      { '<M-C-b>', vim.cmd.bfirst   , desc = 'First buffer'    },
      { '<M-C-n>', vim.cmd.blast    , desc = 'Last buffer'     },
      group = 'buffers',
    },

    --[[ Diagnostic keymaps ]]
    -- stylua: ignore
    { mode = 'n',
      { '[d'       , vim.diagnostic.goto_prev , desc = 'Go to previous diagnostic message' },
      { ']d'       , vim.diagnostic.goto_next , desc = 'Go to next diagnostic message'     },
      { '<leader>e', vim.diagnostic.open_float, desc = 'Open floating diagnostic message'  },
      { '<leader>q', vim.diagnostic.setloclist, desc = 'Open diagnostics list'             },
    },
    -- Miscellaneous
    -- stylua: ignore
    {
      { mode = { 'n', 'v' },
        { '<Space>', '<Nop>', { silent = true } },
      },
      { mode = 'n',
        { '<C-s>', vim.cmd.write, desc = '[S]ave' },
        { '<leader>tf', require('plugins.custom.tail'), desc = '`[t]ail -[f] <buf>`' },
      },
    },
    --[[ Line numbers ]]
    -- stylua: ignore
    { mode = { 'n', 'v' },
      { desc = 'toggle [l]ine number mode',
        '<leader>ll', function()
          local state = vim.o.number
          vim.o.number = not state
          vim.o.relativenumber = state
        end,
      },
      { desc = 'toggle [a]bsolute line numbers',
        '<leader>la', function()
          vim.o.number = not vim.o.number
        end,
      },

      { desc = 'toggle [r]elative line numbers',
        '<leader>lr', function()
          vim.o.relativenumber = not vim.o.relativenumber
        end,
      },
      { desc = 'toggle [h]ybrid line numbers',
        '<leader>lh', function()
          local state = not vim.o.relativenumber
          vim.o.number = state
          vim.o.relativenumber = state
        end,
      },
    },
  },
}

return M
