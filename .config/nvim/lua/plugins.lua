return {

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  { -- proper merge editor
    --- @see documentation at https://github.com/sindrets/diffview.nvim
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    opts = {}
  },

  { -- Repeatable prefixed bindings
    'anuvyklack/hydra.nvim',
    lazy = true,
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { -- symbol navigation
        'SmiteshP/nvim-navbuddy',
        opts = { lsp = { auto_attach = true } },
        dependencies = { 'SmiteshP/nvim-navic', 'MunifTanjim/nui.nvim' },
      },
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim',       opts = {} },
      -- function signatures for nvim's Lua API
      'folke/neodev.nvim',
    },
  },
  -- Linter support
  'mfussenegger/nvim-lint',
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      -- File path completion
      'hrsh7th/cmp-path',
      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  { -- There are way to many statusline plugins, we're using this one.
    'freddiehaddad/feline.nvim',
    opts = {}
  },

  { -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    -- Main options --
    opts = {
      style                = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      transparent          = false,    -- Show/hide background
      term_colors          = true,     -- Change terminal color as per the selected theme style
      ending_tildes        = true,     -- Show the end-of-buffer tildes. By default they are hidden
      cmp_itemkind_reverse = false,    -- reverse item kind highlights in cmp menu

      -- Change code style --
      code_style           = {
        comments  = 'italic', -- Options are italic, bold, underline, none
        keywords  = 'bold',   -- You can configure multiple style with comma separated
        functions = 'none',   -- For example., keywords = 'italic,bold'
        strings   = 'none',
        variables = 'none'
      },
      -- Plugins Config --
      diagnostics          = {
        darker     = true, -- darker colors for diagnostic
        undercurl  = true, -- use undercurl instead of underline for diagnostics
        background = true, -- use background color for virtual text
      },
      -- Custom Highlights --
      highlights           = {}, -- Override highlight groups
      -- Override default colors --
      colors               = {
        black       = "#181a1f",
        bg0         = "#282c34",
        bg1         = "#31353f",
        bg2         = "#393f4a",
        bg3         = "#3b3f4c",
        bg_d        = "#21252b",
        bg_blue     = "#73b8f1",
        bg_yellow   = "#ebd09c",
        fg          = "#abb2bf",
        purple      = "#c678dd",
        green       = "#98c379",
        orange      = "#d19a66",
        blue        = "#61afef",
        yellow      = "#e5c07b",
        cyan        = "#56b6c2",
        red         = "#e86671",
        grey        = "#5c6370",
        light_grey  = "#848b98",
        dark_cyan   = "#2b6f77",
        dark_red    = "#993939",
        dark_yellow = "#93691d",
        dark_purple = "#8a3fa0",
        diff_add    = "#31392b",
        diff_delete = "#382b2c",
        diff_change = "#1c3448",
        diff_text   = "#2c5372",
      },
    },
    config = function(_, opts)
      require('onedark').setup(opts)
      vim.cmd.colorscheme 'onedark'
    end
  },
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = { -- See `:help gitsigns.txt`
        add          = { text = '' },
        change       = { text = '⦿' },
        delete       = { text = '' },
        topdelete    = { text = '' },
        changedelete = { text = '⦿' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>ghp', require('gitsigns').preview_hunk,
          { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns

        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })

        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },


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

  { -- bulk comments
    'numToStr/Comment.nvim',
    opts = {
      padding   = true,
      sticky    = true,
      mappings  = { basic = true, extra = true },
      toggler   = { line = '<leader>cc', block = '<leader>bb' },
      opleader  = { line = '<leader>c', block = '<leader>b' },
      extra     = { above = '<leader>cO', below = '<leader>co', eol = '<leader>cA' },
      pre_hook  = nil,
      post_hook = nil,
      ignore    = nil,
    },
    -- lazy =false
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
          return vim.fn.executable 'make' == 1
        end,
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
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  { -- Hex color highlighting
    'NvChad/nvim-colorizer.lua',
    opts = {
      user_default_options = { names = false },
      buftypes = {
        "*",
        "!prompt", -- exclude prompt and popup buftypes from highlight
        "!popup",
      },
    },
  },
  -- Hex test:
  -- #000000 #000080 #0000ff #008000 #008080 #0080ff #00ff00 #00ff80 #00ffff
  -- #800000 #800080 #8000ff #808000 #808080 #8080ff #80ff00 #80ff80 #80ffff
  -- #ff0000 #ff0080 #ff00ff #ff8000 #ff8080 #ff80ff #ffff00 #ffff80 #ffffff

  { -- Code minimap
    'echasnovski/mini.map',
    opts = {
      symbols = { scroll_line = '⦿', scroll_view = '┃' },
      window  = { show_integration_count = true }
    },
  },
  { -- ergonomic window movements
    'sindrets/winshift.nvim',
    opts = {
      keymaps = { disable_defaults = true }
    },
    -- { -- A port of the Better Comments extension for VS Code to Neovim
    --   'TomJo2000/better-comments.nvim',
    --   opts = {
    --     tags = {
    --       { -- ** Highlight
    --         name = '**', fg = '#0AA342', bg = '', bold = false, --[[ italic = false, underline = false, strikethrough = false ]] },
    --       { -- ?? Informational
    --         name = '??', fg = '#0759B6', bg = '', bold = false, --[[ italic = false, underline = false, strikethrough = false ]] },
    --       { -- >< Ancillary
    --         name = '><', fg = '#0C8167', bg = '', bold = false, --[[ italic = true, underline = false, strikethrough = false ]] },
    --       { -- !! Important
    --         name = '!!', fg = '#DF0D0B', bg = '', bold = false, --[[ italic = false, underline = false, strikethrough = false ]] },
    --       { -- ~~ Invalidated
    --         name = '~~', fg = '#4F4D4B', bg = '', bold = true, --[[ italic = true, underline = false, strikethrough = true ]] },
    --       { -- <> Top Level blocks
    --         name = '<>', fg = '#0759B6', bg = '', bold = true, --[[ italic = true, underline = false, strikethrough = false ]] },
    --       { -- |> nested blocks
    --         name = '|>', fg = '#B84FE0', bg = '', bold = true, --[[ italic = false, underline = false, strikethrough = false ]] },
    --       { -- (TODO) Todo comments
    --         name = '(TODO)', fg = '#EDBA04', bg = '', bold = false, --[[ italic = true, underline = false, strikethrough = false ]] },
    --       { -- (WIP) Work in Progress comments
    --         name = '(WIP)', fg = '#F36D11', bg = '', bold = false, --[[ italic = true, underline = false, strikethrough = false ]] },
    --       { -- (ACK) Code contribution acknowledgements
    --         name = '(ACK)', fg = '#B7208F', bg = '', bold = false, --[[ italic = false, underline = false, strikethrough = false ]] },
    --       { -- (RegEx) additional explanations for Regular Expressions
    --         name = '(RegEx)', fg = '#06C2F7', bg = '', bold = false, --[[ italic = false, underline = true, strikethrough = false ]] },
    --     },
    --     config = function(_, opts)
    --       require('better-comments').Setup(opts)
    --     end
    --   },
    -- },
  },
  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}
