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
         │   ├── lsp
         │   │   ├── bashls.lua
         │   │   ├── gopls.lua
         │   │   ├── init.lua
         │   │   └── lua_ls.lua
         │   └── treesitter.lua
         ├── keybinds.lua
         ├── kickstart
         │   └── plugins
         │       ├── autoformat.lua
         │       └── debug.lua
         ├── options.lua
         ├── plugins.lua
         └── posthoc.lua

8 directories, 22 files
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

