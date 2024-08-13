--[[ Bootstrap `lazy.nvim` plugin manager ]]
---@see Lazy.nvim https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { -- A fully customizable start screen
    'goolord/alpha-nvim',
    cond = vim.fn.expand('%') == '',
    event = 'CmdUndefined',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
    },
    config = require('plugins.alpha_nvim'),
  },

  { -- Session persistence and management
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
  },

  { -- directory navigation
    'nvim-tree/nvim-tree.lua',
    priority = 900, -- we want this loaded pretty much immediately
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = require('plugins.nvim-tree'),
  },

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  { -- Keybind management
    'folke/which-key.nvim',
    event = 'VeryLazy',
    -- stylua: ignore
    disable = {
      buftypes = {
        'terminal', 'lspinfo', 'checkhealth',
        'help', 'lazy'
      },
    },
    opts = require('plugins.which-key').opts,
  },

  -- Repeatable prefixed bindings
  { 'anuvyklack/hydra.nvim', event = 'BufEnter' },

  { -- proper merge editor
    event = 'VeryLazy',
    --- @see documentation at https://github.com/sindrets/diffview.nvim
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  { -- More customizable formatters.
    'stevearc/conform.nvim',
    opts = require('plugins.formatter').opts,
  },

  -- Split or join oneliners to multiline statements and vise versa
  { 'AndrewRadev/splitjoin.vim' },

  -- [[ LSP ]]
  { -- LSP Configuration
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
      -- stylua: ignore
      depdencies = {
        'hrsh7th/cmp-nvim-lsp', -- CMP integration
        'folke/neodev.nvim',    -- function signatures for nvim's Lua API
        'onsails/lspkind.nvim', -- icons for LSP suggestions
      },
    config = function()
      local opts = require('plugins.lsp')
      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      for lsp, conf in pairs(opts) do
        local default_config = require('lspconfig')[lsp].document_config.default_config
        ---@diagnostic disable: redefined-local
        local conf = vim.tbl_deep_extend('force', default_config, conf)
        -- Ensure the servers above are installed
        if vim.fn.executable(conf.cmd[1]) ~= 1 then
          vim.cmd.echohl('LspDiagnosticsVirtualTextError')
          vim.cmd.echomsg(('"Could not find: %s"'):format(conf.cmd[1]))
          vim.cmd.echohl('NONE')
        end

        require('lspconfig')[lsp].setup(conf)
      end
    end,
  },

  { -- Useful status updates for LSP
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {},
  },

  { -- Generic LSP injections via Lua
    'nvimtools/none-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local none = require('null-ls')
      none.setup({
          -- stylua: ignore
          sources = {
            none.builtins.code_actions.gitrebase, -- inject a code action for fast git rebase interactive mode switching
            none.builtins.diagnostics.actionlint, -- GitHub Actions linter
            none.builtins.diagnostics.yamllint,   -- YAML linter
            none.builtins.completion.luasnip,     -- LuaSnip snippets as completions
            none.builtins.completion.spell,       -- Spelling suggestions as completions
          },
        update_in_insert = true,
        debounce = 150,
        -- debug = true,
      })
    end,
  },

  { -- LSP context breadcrumbs
    'SmiteshP/nvim-navic',
    event = 'LspAttach',
    dependencies = {
      'neovim/nvim-lspconfig',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons', -- NerdFont icons
    },
    config = require('plugins.breadcrumbs'),
  },

  { -- Highlighters, Querries and Contexts.
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = require('plugins.treesitter').ts,
  },

  { -- bulk comments
    'numToStr/Comment.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects', -- Syntax aware text-objects
      'JoosepAlviste/nvim-ts-context-commentstring', -- set the commentstring based on the treesitter context
    },
    opts = {
      padding = true,
      sticky = true,
      mappings = { basic = true, extra = true },
      opleader = { line = '<leader>c', block = '<leader>b' },
      toggler = { line = '<leader>cc', block = '<leader>bb' },
      extra = { above = '<leader>cO', below = '<leader>co', eol = '<leader>cA' },
      -- pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      post_hook = nil,
      ignore = nil,
    },
  },

  { -- Show the current context
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = require('plugins.treesitter').context,
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
      -- stylua: ignore
      dependencies = {
        'hrsh7th/cmp-calc',                    -- Math
        'Dosx001/cmp-commit',                  -- Repo contents
        -- 'uga-rosa/cmp-dynamic',             -- Generates suggestions from Lua functions
        'petertriho/cmp-git',                  -- Git
        'saadparwaiz1/cmp_luasnip',            -- LuaSnip cmp source
        'hrsh7th/cmp-nvim-lsp-signature-help', -- LSP powered function signatures
        'hrsh7th/cmp-nvim-lsp',                -- Adds LSP completion capabilities
        'hrsh7th/cmp-omni',                    -- Neovim Omnifunc
        'hrsh7th/cmp-path',                    -- File path completion
        'chrisgrieser/cmp_yanky',              -- Clipboard/Yank history
        'rafamadriz/friendly-snippets',        -- Adds a number of user-friendly snippets
        'onsails/lspkind.nvim',                -- Icons for LSP suggestions
        'L3MON4D3/LuaSnip',                    -- Snippet Engine
      },
    config = require('plugins.cmp'),
  },

  { -- There are way to many statusline plugins, we're using this one.
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = require('plugins.lualine'),
  },

  { -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000, -- make sure the colorscheme is loaded immediately
    config = function() -- this goes haywire if I pass in the config using the opts key for some reason
      local opts = require('plugins.onedark').config
      ---@diagnostic disable: different-requires
      require('onedark').setup(opts)
      vim.cmd.colorscheme('onedark')
    end,
  },

  { -- Git diffs in the status column
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = require('plugins.gitsigns'),
  },

  --(TODO): https://dotfyle.com/plugins/HakonHarnes/img-clip.nvim

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = require('plugins.indents').ibl,
    dependencies = { -- Taste the rainbow
      'HiPhish/rainbow-delimiters.nvim',
      config = require('plugins.indents').rainbow_delimiters,
    },
  },

  { -- Custom comment highlights
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- opts = {
    --
    -- }
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
    },
  },

  { -- Markdown preview in the browser synced to nvim
    'iamcco/markdown-preview.nvim',
    event = 'VeryLazy',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown', 'html' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },

  { -- Hex color highlighting
    'NvChad/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      user_default_options = { names = false },
          -- stylua: ignore
          buftypes = {
            '*',
            '!prompt', -- exclude prompts
            '!popup',  -- exclude popups
            '!lazy',   -- exclude lazy.nvim
          },
    },
  },
  -- Hex test:
  -- #000000 #000080 #0000ff #008000 #008080 #0080ff #00ff00 #00ff80 #00ffff
  -- #800000 #800080 #8000ff #808000 #808080 #8080ff #80ff00 #80ff80 #80ffff
  -- #ff0000 #ff0080 #ff00ff #ff8000 #ff8080 #ff80ff #ffff00 #ffff80 #ffffff

  { -- Code minimap
    'echasnovski/mini.map',
    event = 'VeryLazy',
    keys = require('plugins.mini.map').binds,
    dependencies = {
      'echasnovski/mini.diff', -- diff highlighting
      'lewis6991/gitsigns.nvim', -- git highlighting
    },
    config = require('plugins.mini.map').config,
  },

  { -- Add, delete, replace, find, highlight surrounding characters
    'echasnovski/mini.surround',
    event = 'VeryLazy',
    opts = require('plugins.mini.surround').opts,
  },

  { -- Per project file shortcuts
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = true,
  },

  { -- Ergonomic window movements
    'sindrets/winshift.nvim',
    cmd = 'WinShift',
    event = 'CmdUndefined',
    opts = {
      keymaps = { disable_defaults = true },
    },
    -- stylua: ignore
    keys = { -- Moving windows more better
      { '<C-w><C-w>'        , '<Cmd>WinShift swap<CR>'     , { mode = 'n', desc = 'Swap [w]indow' }           },
      { '<C-w><C-Up>'       , '<Cmd>WinShift up<CR>'       , { mode = 'n', desc = 'Swap window <Up>' }        },
      { '<C-w><C-Down>'     , '<Cmd>WinShift down<CR>'     , { mode = 'n', desc = 'Swap window <Down>' }      },
      { '<C-w><C-Left>'     , '<Cmd>WinShift left<CR>'     , { mode = 'n', desc = 'Swap window <Left>' }      },
      { '<C-w><C-Right>'    , '<Cmd>WinShift right<CR>'    , { mode = 'n', desc = 'Swap window <Right>' }     },
      { '<C-S-w><C-S-Up>'   , '<Cmd>WinShift far_up<CR>'   , { mode = 'n', desc = 'Swap window far <UP>' }    },
      { '<C-S-w><C-S-Down>' , '<Cmd>WinShift far_down<CR>' , { mode = 'n', desc = 'Swap window far <DOWN>' }  },
      { '<C-S-w><C-S-Left>' , '<Cmd>WinShift far_left<CR>' , { mode = 'n', desc = 'Swap window far <LEFT>' }  },
      { '<C-S-w><C-S-Right>', '<Cmd>WinShift far_right<CR>', { mode = 'n', desc = 'Swap window far <RIGHT>' } },
    },
  },

  { -- Incremental renaming
    'smjonas/inc-rename.nvim',
    opts = { cmd_name = 'Rename' },
    cmd = 'Rename',
    keys = {
      {
        '<leader>rn',
        vim.cmd.Rename,
        { mode = { 'n', 'v' }, desc = 'Incremental [r]e[n]ame' },
      },
    },
  },

  { -- Discord Rich Presence
    'andweeb/presence.nvim',
    event = 'VeryLazy',
    cond = function() -- Only load this plugin if Discord is installed.
      return vim.fn.executable('discord') == 1 and true or false
    end,
    config = function()
      local opts = require('plugins.presence')
      require('presence').setup(opts)
    end,
  },

  { -- yank history
    'gbprod/yanky.nvim',
    event = 'SafeState',
    opts = {
      ring = { -- yank ring
        history_length = 100,
        storage = 'shada',
        sync_with_numbered_registers = true,
        cancel_event = 'update',
        ignore_registers = { '_' },
        update_register_on_cycle = false,
      },
      system_clipboard = {
        sync_with_ring = true,
      },
    },
  },
  ---@diagnostic disable: different-requires
}, require('plugins.lazy'))
