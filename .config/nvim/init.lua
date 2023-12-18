--[[
TomIO's neovim config.
Based on Kickstarter.nvim
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
-- https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
-- You can configure plugins using the `config` key.
--
-- You can also configure plugins after the setup call,
-- as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { -- symbol navigation
        'SmiteshP/nvim-navbuddy',
        opts = { lsp = { auto_attach = true } },
        dependencies = { 'SmiteshP/nvim-navic', 'MunifTanjim/nui.nvim' },
      },
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },
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
      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    opts = {}
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

  { -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    opts = {                           -- Main options --
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
        darker = true,    -- darker colors for diagnostic
        undercurl = true, -- use undercurl instead of underline for diagnostics
        background = true --use background color for virtual text
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
  -- There are way to many statusline plugins, we're using this one.
  { 'freddiehaddad/feline.nvim', opts = {} },

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
  { -- more ergonomic window rearrangement
    'sindrets/winshift.nvim', opts = { keymaps = { disable_defaults = true } },
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
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Whitespace symbols
vim.opt.listchars = {
  space = '∙',
  tab = '░ ',
  trail = '◦',
  extends = '»',
  precedes = '«',
  nbsp = '⣿'
}
vim.o.list = true

vim.o.tabstop = 4
vim.o.expandtab = true

-- Set highlight on search
vim.o.hlsearch = false

-- Make (absolute) line numbers default
vim.wo.number = true

-- toggle between absolute and relative line numbers with <leader>ll
vim.keymap.set({ 'n', 'v' }, '<leader>ll', function()
  local state = vim.o.number
  vim.o.number = not state
  vim.o.relativenumber = state
end, { desc = 'toggle [l]ine number mode' })

vim.keymap.set({ 'n', 'v' }, '<leader>la', function()
  vim.o.number = not vim.o.number
end, { desc = 'toggle [a]bsolute line numbers' })

vim.keymap.set({ 'n', 'v' }, '<leader>lr', function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = 'toggle [r]elative line numbers' })

vim.keymap.set({ 'n', 'v' }, '<leader>lh', function()
  local state = not vim.o.relativenumber
  vim.o.number = state
  vim.o.relativenumber = state
end, { desc = 'toggle [h]ybrid line numbers' })

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Moving lines ]]

vim.keymap.set('n', '<M-Down>', 'ddp', { desc = 'Swap line down' })
vim.keymap.set('n', '<M-Up>', 'ddkP', { desc = 'Swap line up' })
vim.keymap.set('n', '<M-C-Down>', 'yyp', { desc = 'Copy line below' })
vim.keymap.set('n', '<M-C-Up>', 'yyP', { desc = 'Copy line above' })
vim.keymap.set('v', '<M-Down>', 'yjp', { desc = 'Copy selection below' })
vim.keymap.set('v', '<M-Up>', 'y^i<cr><Esc>kp', { desc = 'Copy selection above' })

vim.keymap.set('n', '<C-s>', '<cmd>w<cr>', { desc = '[S]ave' })

-- [[ Moving windows more better ]]
vim.keymap.set('n', '<C-w><C-w>', '<Cmd>WinShift swap<CR>', { desc = 'Swap [w]indow' })
vim.keymap.set('n', '<C-w><C-Left>', '<Cmd>WinShift left<CR>', { desc = 'Swap window <Left>' })
vim.keymap.set('n', '<C-w><C-Right>', '<Cmd>WinShift right<CR>', { desc = 'Swap window <Right>' })
vim.keymap.set('n', '<C-w><C-Up>', '<Cmd>WinShift up<CR>', { desc = 'Swap window <Up>' })
vim.keymap.set('n', '<C-w><C-Down>', '<Cmd>WinShift down<CR>', { desc = 'Swap window <Down>' })
vim.keymap.set('n', '<C-S-w><C-S-Left>', '<Cmd>WinShift far_left<CR>', { desc = 'Swap window far <LEFT>' })
vim.keymap.set('n', '<C-S-w><C-S-Right>', '<Cmd>WinShift far_right<CR>', { desc = 'Swap window far <RIGHT>' })
vim.keymap.set('n', '<C-S-w><C-S-Up>', '<Cmd>WinShift far_up<CR>', { desc = 'Swap window far <UP>' })
vim.keymap.set('n', '<C-S-w><C-S-Down>', '<Cmd>WinShift far_down<CR>', { desc = 'Swap window far <DOWN>' })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = { git_root },
    })
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = '[G]it [F]ile search' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  ---@diagnostic disable-next-line
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      'c', 'cpp', 'go', 'lua',
      'python', 'rust', 'tsx', 'javascript',
      'typescript', 'vimdoc', 'vim', 'bash'
    },
    -- sync_install = '',
    -- ignore_install = '',
    -- modules = '',
    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- A function that lets us more easily define mappings specific for LSP related items.
  -- It sets the mode, buffer and description for us each time.
  ---@alias mode
  ---|"'n'" # normal mode
  ---|"'i'" # insert mode
  ---|"'v'" # visual mode
  ---|"'c'" # command mode
  ---|"'r'" # replace mode
  ---@param modes mode | table<mode> # one or more modes
  ---@param keys string              # the keybinding
  ---@param func string | function   # action to trigger
  ---@param desc string?             # description (optional)
  local lsp_map = function(modes, keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set(modes, keys, func, { buffer = bufnr, desc = desc })
  end

  lsp_map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  lsp_map('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  local telescope = require('telescope.builtin')
  lsp_map('n', 'gd', telescope.lsp_definitions, '[G]oto [D]efinition')
  lsp_map('n', 'gr', telescope.lsp_references, '[G]oto [R]eferences')
  lsp_map('n', 'gI', telescope.lsp_implementations, '[G]oto [I]mplementation')
  lsp_map('n', '<leader>D', telescope.lsp_type_definitions, 'Type [D]efinition')
  lsp_map('n', '<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')
  lsp_map('n', '<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  lsp_map('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
  lsp_map('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  lsp_map('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  lsp_map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  lsp_map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  lsp_map('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

MiniMap = require('mini.map')
vim.keymap.set('n', '<Leader>mm', MiniMap.toggle, { desc = '[M]ini.[m]ap toggle' })
vim.keymap.set('n', '<Leader>mo', MiniMap.open, { desc = '[M]ini.map [o]pen' })
vim.keymap.set('n', '<Leader>mc', MiniMap.close, { desc = '[M]ini.map [c]lose' })
vim.keymap.set('n', '<Leader>mr', MiniMap.refresh, { desc = '[M]ini.map [r]efresh' })
MiniMap.open()

-- document existing key chains
require('which-key').register {
  ['<leader>c']  = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d']  = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g']  = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>gh'] = { name = '[G]it [h]unks', _ = 'which_key_ignore' },
  ['<leader>r']  = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s']  = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>w']  = { name = '[W]orkspace', _ = 'which_key_ignore' },
  -- my key chains
  ['<leader>l']  = { name = '[L]ine numbers', _ = 'which_key_ignore' },
  ['<leader>m']  = { name = '[M]ini.map', _ = 'which_key_ignore' },
}

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      ---@see workspace = { checkThirdParty = false },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        ---@see telemetry = { enable = false },
        ---@see NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        ---@see diagnostics = { disable = { 'missing-fields' } },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    }
  },
  bashls = {},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = cmp.mapping.preset.insert {
    ['<Esc>'] = cmp.mapping.close(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

require('editorconfig')
