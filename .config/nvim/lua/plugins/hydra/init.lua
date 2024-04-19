local Hydra = require('hydra')
---@source ./replace.lua
Hydra(require('plugins.hydra.replace'))
---@source ./git_hydra.lua
Hydra(require('plugins.hydra.git_hydra'))
---@source ./side_scroll.lua
Hydra(require('plugins.hydra.side_scroll'))
---@source ./resize_split.lua
-- Hydra(require('plugins.hydra.resize_split'))
