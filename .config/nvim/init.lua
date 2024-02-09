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

${XDG_CONFIG_HOME}/nvim
├── lua
│   ├── config
│   │   ├── hydra
│   │   │   ├── git_hydra.lua
│   │   │   ├── init.lua
│   │   │   ├── replace.lua
│   │   │   ├── resize_split.lua
│   │   │   └── side_scroll.lua
│   │   ├── lsp
│   │   │   ├── bashls.lua
│   │   │   ├── init.lua
│   │   │   └── lua_ls.lua
│   │   ├── telescope
│   │   │   ├── binds.lua
│   │   │   ├── delta.lua
│   │   │   └── init.lua
│   │   ├── cmp.lua
│   │   ├── delims.lua
│   │   ├── feline.lua
│   │   ├── git.lua
│   │   ├── mini_map.lua
│   │   ├── treesitter.lua
│   │   └── which_key.lua
│   ├── kickstart
│   │   ├── autoformat.lua
│   │   └── debug.lua
│   ├── plugins
│   │   ├── alpha_nvim.lua
│   │   ├── formatter.lua
│   │   ├── gitsigns.lua
│   │   ├── init.lua
│   │   └── onedark.lua
│   ├── utils
│   │   ├── capture.lua
│   │   └── init.lua
│   ├── keybinds.lua
│   ├── options.lua
│   └── posthoc.lua
├── init.lua
└── lazy-lock.json

9 directories, 32 files
]]

-- [[ Setting options ]]
---@source ./lua/options.lua
require('options')

-- [[ Configure plugins ]]
---@source ./lua/plugins.lua
require('plugins')

-- [[ Setup keybindings ]]
---@source ./lua/keybinds.lua
require('keybinds')

-- [[ Posthoc plugin configuration ]]
---@source ./lua/posthoc.lua
require('posthoc')

