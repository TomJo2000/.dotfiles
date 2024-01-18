--[[
TomIO's neovim config.
Based on Kickstarter.nvim
--]]
---@see forked_at
---|#ee9790b (Nov 24 2023)
---| https://github.com/nvim-lua/kickstart.nvim/tree/ee9790b381416781063d0de6653b303f10ed89b0

---@see tracking_to
---|#2510c29 upstream commit (Jan 10 2024)
---| https://github.com/nvim-lua/kickstart.nvim/tree/2510c29d62d39d63bb75f1a613d2ae628a2af4ee

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
---@see Lazy.nvim https://github.com/folke/lazy.nvim
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

-- Config layout
--[[ ${XDG_CONFIG_HOME}/nvim
     ├── doc
     │   └── tags
     ├── init.lua
     ├── lazy-lock.json
     └── lua
         ├── config
         │   ├── cmp.lua
         │   ├── colorscheme.lua
         │   ├── feline.lua
         │   ├── git.lua
         │   ├── hydra
         │   │   ├── git_hydra.lua
         │   │   ├── init.lua
         │   │   ├── resize_split.lua
         │   │   └── side_scroll.lua
         │   └── lsp
         │       ├── bashls.lua
         │       ├── gopls.lua
         │       └── lua_ls.lua
         ├── keybinds.lua
         ├── kickstart
         │   └── plugins
         │       ├── autoformat.lua
         │       └── debug.lua
         ├── options.lua
         └── plugins.lua

8 directories, 19 files
]]

-- [[ Setting options ]]
require('options')

-- [[ Configure plugins ]]
require('lazy').setup('plugins', {})

-- [[ Setup keybindings ]]
require('keybinds')

---@deprecated local config_path = vim.fn.stdpath('config') .. '/lua/config'

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

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      'bash', 'c', 'cpp', 'diff', 'go', 'git_config', 'gitignore',
      'ini', 'lua', 'python', 'regex', 'rust', 'ssh_config',
      'toml', 'typescript', 'vimdoc', 'vim', 'yaml'
    },
    -- sync_install = '',
    -- ignore_install = '',
    -- modules = '',
    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,
    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- List of parsers to ignore installing
    ignore_install = {},
    -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
    modules = {},

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
    { name = 'path' },
  },
}

require('editorconfig')
