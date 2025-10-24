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
  { -- A collection of QoL plugins
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    -- stylua: ignore
    ---@type snacks.Config
    opts = {
      -- I want to gradually opt into the modules I actually want.
      dashboard = require('plugins.snacks.dashboard'),
      gitbrowse = require('plugins.snacks.gitbrowse'),
          input = require('plugins.snacks.input'),
        scratch = require('plugins.snacks.scratch'),
    },
  },

  { -- Session persistence and management
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
  },

  { -- Nicer folds
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'VeryLazy',
    opts = require('plugins.folds'),
    init = function()
      vim.o.foldcolumn = '1'
      -- UFO requires a high base foldlevel to work.
      vim.o.foldlevel = 32
      vim.o.foldlevelstart = 32
      vim.o.foldenable = true
      -- Default to treesitter folding
      vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      -- Fold decorations
      vim.opt.fillchars = {
        fold = ' ',
        foldclose = '',
        -- foldinner = ' ', ---@since Neovim 0.11.5
        foldopen = '',
        foldsep = ' ',
      }
    end,
  },

  { -- directory navigation
    'nvim-tree/nvim-tree.lua',
    event = 'VeryLazy',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = require('plugins.nvim-tree'),
    keys = {
      { '<leader>ee', '<Cmd>NvimTreeToggle<CR>', { mode = 'n', desc = 'Toggle file tr[ee]' } },
    },
  },

  -- Git related plugins
  { 'tpope/vim-fugitive', event = 'VeryLazy' },

  { 'tpope/vim-rhubarb', event = 'VeryLazy' },

  -- Detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth', event = 'BufEnter' },

  { -- Keybind management
    'folke/which-key.nvim',
    event = 'BufEnter',
    opts = require('plugins.which-key').opts,
    -- stylua: ignore
    disable = {
      buftypes = {
        'alpha', 'checkhealth', 'help',
        'lazy', 'lspinfo', 'terminal',
      },
    },
  },

  -- Repeatable prefixed bindings
  { 'nvimtools/hydra.nvim', event = 'BufEnter' },

  { -- proper merge editor
    --- @see documentation at https://github.com/sindrets/diffview.nvim
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  { -- More customizable formatters.
    'stevearc/conform.nvim',
    event = 'BufEnter',
    dir = '/home/tom/git/conform.nvim/',
    opts = require('plugins.formatter').opts,
  },

  -- Split or join one-liners to multiline statements and vice versa
  { 'AndrewRadev/splitjoin.vim', event = 'InsertEnter' },

  { 'kevinhwang91/nvim-bqf', ft = 'qf' },

  { -- Less obtrusive notifications
    'j-hui/fidget.nvim',
    event = 'VeryLazy',
    opts = {
      notification = {
        override_vim_notify = true,
        window = { avoid = { 'NvimTree' } },
      },
      -- window = { zindex = 45 },
    },
  },

  -- [[ LSP ]]
  { -- LSP management
    'mason-org/mason.nvim',
    lazy = true,
    opts = {
      install_root_dir = vim.fn.stdpath('state') .. '/lsp',
      PATH = 'append',
    },
  },

  {
    'mason-org/mason-lspconfig.nvim',
    -- event = { 'BufReadPre', 'BufNewFile' },
    lazy = true,
    dependencies = {
      'mason-org/mason.nvim',
      { -- LSP Configuration
        'neovim/nvim-lspconfig',
        -- stylua: ignore
        dependencies = {
          'folke/lazydev.nvim',   -- Function signatures for nvim's Lua API
          'onsails/lspkind.nvim', -- Icons for LSP suggestions
          'j-hui/fidget.nvim',    -- vim.notify replacement
        },
      },
    },
  },

  { -- function signatures for nvim's Lua API
    'folke/lazydev.nvim',
    ft = 'lua',
    dependencies = { 'DrKJeff16/wezterm-types' },
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        -- Load the wezterm types when the `wezterm` module is required
        -- Needs `DrKJeff16/wezterm-types` to be installed
        { path = 'wezterm-types', mods = { 'wezterm' } },
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
        sources = {
          none.builtins.diagnostics.actionlint, -- GitHub Actions linter
          none.builtins.code_actions.gitrebase, -- inject a code action for fast git rebase interactive mode switching
          none.builtins.completion.spell, -- Spelling suggestions as completions
          none.builtins.diagnostics.yamllint, -- YAML linter
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
    opts = require('plugins.breadcrumbs'),
  },

  { -- Highlighters, Queries and Contexts.
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    opts = require('plugins.treesitter').ts,
    dependencies = {
      -- Automatically install selected parsers
      'lewis6991/ts-install.nvim',
      opts = require('plugins.treesitter').install,
    },
  },

  { -- Bulk comments
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    -- dependencies = {
    --   'nvim-treesitter/nvim-treesitter-textobjects', -- Syntax aware text-objects
    -- },
    opts = {
      padding = true,
      sticky = true,
      mappings = { basic = true, extra = true },
      opleader = { line = '<leader>c', block = '<leader>b' },
      toggler = { line = '<leader>cc', block = '<leader>bb' },
      extra = { above = '<leader>cO', below = '<leader>co', eol = '<leader>cA' },
      pre_hook = nil,
      post_hook = nil,
      ignore = nil,
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    version = '1.*', -- use a release tag to download pre-built binaries
    dependencies = { 'L3MON4D3/LuaSnip' },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'enter' },
      appearance = { nerd_font_variant = 'mono' },
      signature = { enabled = true },
      snippets = { preset = 'luasnip' },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
      ---@source Fuzzy/Sorting Mega issue
      ---|https://github.com/Saghen/blink.cmp/issues/1642#issuecomment-2960900872
      completion = {
        documentation = { auto_show = true },
        menu = { auto_show = true },
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        },
      },
      fuzzy = {
        implementation = 'prefer_rust_with_warning', -- currently kinda broken
        -- implementation = 'lua',
        sorts = { 'exact', 'score', 'sort_text' },
        frecency = {
          enabled = false,
        },
        use_proximity = false,
        max_typos = function()
          return 0
        end,
      },
    },
    opts_extend = { 'sources.default' },
  },

  { -- Snippet engine
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    -- install jsregexp (optional).
  },

  -- automatically close tags in HTML, XML or embedded in Markdown
  { 'windwp/nvim-ts-autotag' },

  { -- Colorized icons for filetypes, etc.
    'nvim-tree/nvim-web-devicons',
    opts = {
      override = {
        just = {
          icon = '󰫷',
          color = '#CC9057',
          cterm_color = '215',
          name = 'just',
        },
        lua = {
          icon = '',
          color = '#0759B6',
          cterm_color = '4',
        },
        markdown = {
          icon = '',
          color = '#B0B2B4',
          cterm_color = '250',
        },
        vimdoc = {
          icon = '',
          color = '#25982D',
          cterm_color = '34',
        },
      },
    },
  },

  { -- There are way to many statusline plugins, we're using this one.
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'SmiteshP/nvim-navic',
    },
    opts = require('plugins.lualine'),
  },

  { -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 900, -- make sure the colorscheme is loaded immediately
    dependencies = 'rktjmp/lush.nvim',
    config = function()
      ---@type onedark.opts
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
    ft = { 'markdown', 'html' },
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
        '!alpha',  -- exclude dashboard
        '!lazy',   -- exclude lazy.nvim
        '!popup',  -- exclude menus
        '!prompt', -- exclude prompts
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
    enabled = function() -- Only load this plugin if Discord is installed.
      return (vim.fn.executable('discord') == 1 or vim.fn.executable('discord-canary') == 1)
    end,
    opts = require('plugins.presence'),
  },
}, require('plugins.lazy'))
