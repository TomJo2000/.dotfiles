local Hydra = require('hydra')
---@source ./replace.lua
Hydra(require('config.hydra.replace'))
---@source ./git_hydra.lua
Hydra(require('config.hydra.git_hydra'))
---@source ./side_scroll.lua
Hydra(require('config.hydra.side_scroll'))
---@source ./resize_split.lua
-- Hydra(require('config.hydra.resize_split'))

