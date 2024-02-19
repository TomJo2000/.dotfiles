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

  -- Session persistence and management
  { 'folke/persistence.nvim', lazy = true },

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VeryLazy',
    disable = {
      -- stylua: ignore
      buftypes = {
        'terminal', 'lspinfo', 'checkhealth',
        'help', 'lazy', 'mason',
      },
    },
  },

  -- Repeatable prefixed bindings
  { 'anuvyklack/hydra.nvim', lazy = true },

  { -- proper merge editor
    --- @see documentation at https://github.com/sindrets/diffview.nvim
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = true,
  },

  { -- More customizable formatters.
    'mhartington/formatter.nvim',
    config = require('plugins.formatter'),
  },

  -- Split or join oneliners to multiline statements and vise versa
  { 'AndrewRadev/splitjoin.vim' },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    -- stylua: ignore
    dependencies = {
      { -- LSP context breadcrumbs
        'SmiteshP/nvim-navic',
        dependencies = {
          'nvim-tree/nvim-web-devicons', -- NerdFont icons
          { -- Breadcrumb menu
            'SmiteshP/nvim-navbuddy',
            dependencies = 'MunifTanjim/nui.nvim'
          },
        },
        opts = require('config.breadcrumbs'),
        event = 'LspAttach',
      },
      { -- Automatically install LSPs to stdpath for Neovim
        'williamboman/mason.nvim',
        dependencies = {
          'williamboman/mason-lspconfig.nvim', -- Mason/lspconfig interop
        },
        config = true,
      },
      'j-hui/fidget.nvim',    -- Useful status updates for LSP
      'folke/neodev.nvim',    -- function signatures for nvim's Lua API
      'onsails/lspkind.nvim', -- icons for LSP suggestions
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
    lazy = true,
  },

  { -- There are way to many statusline plugins, we're using this one.
    'freddiehaddad/feline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  { -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000, -- make sure the colorscheme is loaded immediately
    config = function()
      require('onedark').setup(require('plugins.onedark'))
      vim.cmd.colorscheme('onedark')
    end,
  },

  { -- Git diffs in the status column
    'lewis6991/gitsigns.nvim',
    opts = require('plugins.gitsigns'),
  },

  --(TODO): https://dotfyle.com/plugins/HakonHarnes/img-clip.nvim

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Tree-sitter based bracket pair highlighting
    dependencies = { 'HiPhish/rainbow-delimiters.nvim' },
    main = 'ibl',
    config = require('config.indents'),
    event = 'BufEnter',
  },

  { -- set the commentstring based on the treesitter context
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = { 'numToStr/Comment.nvim' }, -- bulk comments
  },

  { -- Custom comment highlights
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- opts = {
    --
    -- }
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
    lazy = true,
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
    ft = { 'markdown', 'html' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    lazy = true,
  },

  { -- A reminder for when your lines are getting too long
    'm4xshen/smartcolumn.nvim',
    -- stylua: ignore
    opts = {
      disabled_filetypes = {
        'text', 'markdown', 'html', 'lspinfo',
        'mason', 'help', 'lazy', 'checkhealth',
      },
      custom_colorcolumn = {
        lua = 160,
        sh  = 120,
        zsh = 120,
      },
    },
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
    lazy = true,
  },

  { -- Ergonomic window movements
    'sindrets/winshift.nvim',
    cmd = 'WinShift',
    opts = { -- This can't be lazy since I use it for a keymap
      keymaps = { disable_defaults = true },
    },
  },

  { -- Discord Rich Presence
    'andweeb/presence.nvim',
    cond = function() -- Only load this plugin if Discord is installed.
      return vim.fn.executable('discord') == 1
    end,
    opts = require('plugins.presence'),
    config = function(opts)
      require('presence').setup(opts)
    end,
    lazy = true,
  },
}, require('config.lazy'))
