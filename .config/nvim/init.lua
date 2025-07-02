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

--[[ Config layout

tree -a -l --dirsfirst "$DOT_FILES/.config/nvim/" | tr $'\u00A0' ' '
${XDG_CONFIG_HOME}/nvim
├── after
│     ├── ftplugin
│     │     ├── just.lua
│     │     └── zsh.lua
│     ├── lsp
│     │     ├── bashls.lua
│     │     ├── gopls.lua
│     │     ├── lua_ls.lua
│     │     ├── taplo.lua
│     │     └── zls.lua
│     └── plugin
│         ├── autocmds.lua
│         ├── init.lua
│         ├── keybinds.lua
│         └── mason.lua
├── lua
│     ├── plugins
│     │     ├── alpha
│     │     │     ├── themes
│     │     │     │     ├── logo.txt
│     │     │     │     └── mask.txt
│     │     │     ├── alpha_colored_animation.lua
│     │     │     └── init.lua
│     │     ├── custom
│     │     │     ├── git.lua
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
│     ├── utils
│     │     ├── capture.lua
│     │     ├── deprecated.lua
│     │     ├── init.lua
│     │     ├── memoize.lua
│     │     └── spawn.lua
│     └── options.lua
└── init.lua

14 directories, 46 files
]]

-- [[ Setting options ]]
---@source ./lua/options.lua
require('options')

-- [[ Configure plugins ]]
---@source ./lua/plugins.lua
require('plugins')
