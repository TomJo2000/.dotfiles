--[[ Bootstrap `lazy.nvim` plugin manager ]]
---@see Lazy.nvim https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
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
  -- A fully customizable start screen
  require('plugins.alpha_nvim'),
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim' },

  -- Repeatable prefixed bindings
  { 'anuvyklack/hydra.nvim', lazy = true },

  { -- proper merge editor
    --- @see documentation at https://github.com/sindrets/diffview.nvim
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  { -- More customizable formatters.
    'mhartington/formatter.nvim',
    config = require('plugins.formatter'),
  },

  -- Split or join oneliners to multiline statements and vise versa
  { 'AndrewRadev/splitjoin.vim' },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { -- symbol navigation
        'SmiteshP/nvim-navbuddy',
        opts = { lsp = { auto_attach = true } },
        dependencies = {
          'SmiteshP/nvim-navic',
          'MunifTanjim/nui.nvim',
        },
      },
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },
      -- function signatures for nvim's Lua API
      'folke/neodev.nvim',
      -- icons for LSP suggestions
      'onsails/lspkind.nvim',
    },
  },

  -- Linter support
  { 'mfussenegger/nvim-lint' },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    -- stylua: ignore
    dependencies = {
      'L3MON4D3/LuaSnip',             -- Snippet Engine
      'saadparwaiz1/cmp_luasnip',     -- and its associated nvim-cmp source
      'hrsh7th/cmp-nvim-lsp',         -- Adds LSP completion capabilities
      'hrsh7th/cmp-path',             -- File path completion
      'rafamadriz/friendly-snippets', -- Adds a number of user-friendly snippets
    },
  },

  { -- There are way to many statusline plugins, we're using this one.
    'freddiehaddad/feline.nvim',
    opts = {},
  },

  require('plugins.onedark'),

  require('plugins.gitsigns'),

  --(TODO): https://dotfyle.com/plugins/HakonHarnes/img-clip.nvim

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      -- indent = { char = '|' },
      -- whitespace = {
      --   highlight = { 'Function', 'Label' },
      -- },
    },
  },

  { -- set the commentstring based on the treesitter context
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = { 'numToStr/Comment.nvim' }, -- bulk comments
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
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
        ---@source config = require('config.telescope')
      },
    },
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  { -- Markdown preview in the browser synced to nvim
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },

  { -- Hex color highlighting
    'NvChad/nvim-colorizer.lua',
    opts = {
      user_default_options = { names = false },
      buftypes = {
        '*',
        '!prompt', -- exclude prompt and popup buftypes from highlight
        '!popup',
      },
    },
  },
  -- Hex test:
  -- #000000 #000080 #0000ff #008000 #008080 #0080ff #00ff00 #00ff80 #00ffff
  -- #800000 #800080 #8000ff #808000 #808080 #8080ff #80ff00 #80ff80 #80ffff
  -- #ff0000 #ff0080 #ff00ff #ff8000 #ff8080 #ff80ff #ffff00 #ffff80 #ffffff

  { -- Code minimap
    'echasnovski/mini.map',
    -- branch = 'main',
    config = function()
      require('mini.map').setup(
        ---@source ./config/mini.map.lua
        require('config.mini_map')
      )
    end,
  },

  { -- Per project file shortcuts
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  { -- Ergonomic window movements
    'sindrets/winshift.nvim',
    opts = {
      keymaps = { disable_defaults = true },
    },
  },

  -- Tree-sitter based bracket pair highlighting
  { 'HiPhish/rainbow-delimiters.nvim' },

  { -- Discord Rich Presence
    'andweeb/presence.nvim',
    cond = function()
      return vim.fn.executable('discord') == 1
    end,
    opts = require('plugins.presence'),
    config = function(opts)
      require('presence').setup(opts)
    end,
  },
}, {})
