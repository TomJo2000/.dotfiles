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

tree -a -l --dirsfirst "$DOT_FILES/.config/nvim/"
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
│   │   │   ├── lua_ls.lua
│   │   │   └── taplo.lua
│   │   ├── alpha_nvim.lua
│   │   ├── breadcrumbs.lua
│   │   ├── cmp.lua
│   │   ├── colors.lua
│   │   ├── delims.lua
│   │   ├── delta.lua
│   │   ├── git.lua
│   │   ├── indents.lua
│   │   ├── lazy.lua
│   │   ├── telescope.lua
│   │   └── treesitter.lua
│   ├── kickstart
│   │   ├── autoformat.lua
│   │   └── debug.lua
│   ├── plugins
│   │   ├── mini
│   │   │   ├── map.lua
│   │   │   └── surround.lua
│   │   ├── formatter.lua
│   │   ├── gitsigns.lua
│   │   ├── init.lua
│   │   ├── lualine.lua
│   │   ├── onedark.lua
│   │   ├── presence.lua
│   │   └── telescope.lua
│   ├── utils
│   │   ├── capture.lua
│   │   └── init.lua
│   ├── keybinds.lua
│   ├── options.lua
│   └── posthoc.lua
├── init.lua
├── lazy-lock.json
└── stylua.toml

9 directories, 39 files
]]

-- [[ Setting options ]]
---@source ./lua/options.lua
require('options')

-- [[ Setup keybindings ]]
---@source ./lua/keybinds.lua
require('keybinds')

-- [[ Configure plugins ]]
---@source ./lua/plugins.lua
require('plugins')

-- [[ Posthoc plugin configuration ]]
---@source ./lua/posthoc.lua
require('posthoc')
