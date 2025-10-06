---@forked from kickstart.nvim
---|#ee9790b (Nov 24 2023)
---| https://github.com/nvim-lua/kickstart.nvim/tree/ee9790b381416781063d0de6653b303f10ed89b0

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Configure plugins ]]
---@source ./lua/plugins.lua
require('plugins')

--[[ Config layout

tree -a -l --dirsfirst "$DOT_FILES/.config/nvim/" | tr $'\u00A0' ' '
${XDG_CONFIG_HOME}/nvim
├── after
│     ├── ftplugin
│     │     ├── gitcommit.lua
│     │     ├── just.lua
│     │     └── zsh.lua
│     ├── lsp
│     │     ├── bashls.lua
│     │     ├── gopls.lua
│     │     ├── lua_ls.lua
│     │     ├── taplo.lua
│     │     └── zls.lua
│     ├── plugin
│     │     ├── autocmds.lua
│     │     ├── init.lua
│     │     ├── keybinds.lua
│     │     └── mason.lua
│     └── queries
│         └── editorconfig
│             └── highlights.scm
├── lua
│     ├── plugins
│     │     ├── custom
│     │     │     └── tail.lua
│     │     ├── hydra
│     │     │     ├── git_hydra.lua
│     │     │     ├── init.lua
│     │     │     ├── replace.lua
│     │     │     ├── resize_split.lua
│     │     │     └── side_scroll.lua
│     │     ├── lualine
│     │     │     ├── filename.lua
│     │     │     └── init.lua
│     │     ├── mini
│     │     │     ├── map.lua
│     │     │     └── surround.lua
│     │     ├── snacks
│     │     │     ├── dashboard.lua
│     │     │     ├── gitbrowse.lua
│     │     │     ├── input.lua
│     │     │     └── scratch.lua
│     │     ├── breadcrumbs.lua
│     │     ├── comments.lua
│     │     ├── formatter.lua
│     │     ├── gitsigns.lua
│     │     ├── indents.lua
│     │     ├── init.lua
│     │     ├── lazy.lua
│     │     ├── nvim-tree.lua
│     │     ├── onedark.lua
│     │     ├── presence.lua
│     │     ├── telescope.lua
│     │     ├── treesitter.lua
│     │     └── which-key.lua
│     └── options.lua
└── init.lua

14 directories, 42 files
]]
