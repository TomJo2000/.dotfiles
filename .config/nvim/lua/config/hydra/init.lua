local hydra = require('hydra')
---@source ./replace.lua
-- Hydra(require('plugins.hydra.replace'))
---@source ./git_hydra.lua
hydra(require('config.hydra.git_hydra'))
---@source ./side_scroll.lua
-- Hydra(require('plugins.hydra.side_scroll'))
---@source ./resize_split.lua
hydra(require('config.hydra.resize_split'))
