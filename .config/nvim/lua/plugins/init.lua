--[[ Bootstrap `lazy.nvim` plugin manager ]]
---@see Lazy.nvim https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
local lazydir = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazydir) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazydir,
  })
end
vim.opt.rtp:prepend(lazydir)

require('lazy').setup({
  { -- A fully customizable start screen
    'goolord/alpha-nvim',
    event = 'BufEnter',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('alpha').setup(require('alpha.themes.theta').config)
    end,
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
    keys = {
      { '<leader>ee', '<Cmd>NvimTreeToggle<CR>', { mode = 'n', desc = 'Toggle file tr[ee]' } },
    },
  },

  -- Git related plugins
  { 'tpope/vim-fugitive', event = 'SafeState' },

  { 'tpope/vim-rhubarb', event = 'SafeState' },

  -- Detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth', event = 'BufEnter' },

  { -- Keybind management
    'folke/which-key.nvim',
    event = 'BufEnter',
    opts = require('plugins.which-key').opts,
    -- stylua: ignore
    disable = {
      buftypes = {
        'terminal', 'lspinfo', 'checkhealth',
        'help', 'lazy'
      },
    },
  },

  -- Repeatable prefixed bindings
  { 'nvimtools/hydra.nvim', event = 'BufEnter' },

  { -- proper merge editor
    --- @see documentation at https://github.com/sindrets/diffview.nvim
    'sindrets/diffview.nvim',
    event = 'SafeState',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  { -- More customizable formatters.
    'stevearc/conform.nvim',
    event = 'BufEnter',
    opts = require('plugins.formatter').opts,
  },

  -- Split or join oneliners to multiline statements and vise versa
  { 'AndrewRadev/splitjoin.vim', event = 'InsertEnter' },

  { -- Less obtrusive notifications
    'j-hui/fidget.nvim',
    lazy = true,
    dependencies = { 'nvim-tree/nvim-tree.lua' },
    opts = {
      notification = { override_vim_notify = true },
      integration = {
        ---@see fidget.option.integration.nvim-tree
        ['nvim-tree'] = {
          enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
        },
      },
      -- window = { zindex = 45 },
    },
  },

  -- [[ LSP ]]
  { -- LSP Configuration
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
      -- stylua: ignore
      depdencies = {
        'hrsh7th/cmp-nvim-lsp', -- CMP integration
        'folke/lazydev.nvim',   -- function signatures for nvim's Lua API
        'onsails/lspkind.nvim', -- icons for LSP suggestions
        'j-hui/fidget.nvim',    -- notification
      },
    config = function()
      local opts = require('plugins.lsp')
      local notify = require('fidget').notify
      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      for lsp, conf in pairs(opts) do
        local default_config = require('lspconfig')[lsp].document_config.default_config
        ---@diagnostic disable: redefined-local
        local conf = vim.tbl_deep_extend('force', default_config, conf)
        -- Ensure the servers above are installed
        if vim.fn.executable(conf.cmd[1]) ~= 1 then
          notify(
            ('"Could not find: %s"'):format(conf.cmd[1]), -- msg
            vim.log.levels.WARN, -- level
            { -- opts
              annotate = 'LSP not found:',
              group = 'LspNotFound',
              skip_history = true,
              ttl = 30,
            }
          )
        end

        require('lspconfig')[lsp].setup(conf)
      end
    end,
  },

  { -- function signatures for nvim's Lua API
    'folke/lazydev.nvim',
    ft = 'lua',
    dependencies = { 'Bilal2453/luvit-meta' }, -- optional `vim.uv` typings
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
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
            -- none.builtins.completion.luasnip,     -- LuaSnip snippets as completions
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
    event = 'BufEnter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = require('plugins.treesitter'),
  },

  { -- bulk comments
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
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

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
      -- stylua: ignore
      dependencies = {
        'hrsh7th/cmp-calc',                    -- Math
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
        -- 'L3MON4D3/LuaSnip',                    -- Snippet Engine
      },
    config = require('plugins.cmp'),
  },

  { -- Snippet engine
    'L3MON4D3/LuaSnip',
    -- install jsregexp (optional!).
    build = 'make install_jsregexp',
    cond = function()
      return false -- vim.fn.executable('make') == 1
    end,
  },

  -- automatically close tags in HTML, XML or embedded in Markdown
  { 'windwp/nvim-ts-autotag' },

  { -- There are way to many statusline plugins, we're using this one.
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = require('plugins.lualine'),
  },

  { -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000, -- make sure the colorscheme is loaded immediately
    config = function()
      local opts = require('plugins.onedark').opts
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
      { -- native fzf extension for telescope
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
    },
  },

  { -- nicer looking Markdown
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },

  { -- Markdown preview in the browser synced to nvim
    'iamcco/markdown-preview.nvim',
    event = 'CmdUndefined',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown', 'html' },
    build = function()
      require('lazy').load({ plugins = { 'markdown-preview.nvim' } })
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
    lazy = true,
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
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
    event = 'CmdUndefined',
    cmd = 'Rename',
    opts = { cmd_name = 'Rename' },
    keys = {
      {
        '<leader>rn',
        vim.cmd.Rename,
        { mode = { 'n', 'v' }, desc = 'Incremental [r]e[n]ame' },
      },
    },
  },

  { -- Preview :{number} jumps
    'nacro90/numb.nvim',
    event = 'VeryLazy',
    opts = {
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true, -- Enable 'cursorline' for the window while peeking
      hide_relativenumbers = true, -- Enable turning off 'relativenumber' for the window while peeking
      number_only = false, -- Peek only when the command is only a number instead of when it starts with a number
      centered_peeking = true, -- Peeked line will be centered relative to window
    },
  },

  { -- Discord Rich Presence
    'andweeb/presence.nvim',
    event = 'VeryLazy',
    cond = function() -- Only load this plugin if Discord is installed.
      return vim.fn.executable('discord') == 1 and true or false
    end,
    opts = require('plugins.presence'),
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
