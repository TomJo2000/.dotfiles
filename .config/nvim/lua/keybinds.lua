-- [[ setup keybinds ]]

-- [[ Basic keybinds ]]
-- Moving lines
vim.keymap.set('n', '<M-Down>', 'ddp', { desc = 'Swap line down' })
vim.keymap.set('n', '<M-Up>', 'ddkP', { desc = 'Swap line up' })
vim.keymap.set('n', '<M-C-Down>', 'yyp', { desc = 'Copy line below' })
vim.keymap.set('n', '<M-C-Up>', 'yyP', { desc = 'Copy line above' })
vim.keymap.set('v', '<M-Down>', 'yjp', { desc = 'Copy selection below' })
vim.keymap.set('v', '<M-Up>', 'ykp', { desc = 'Copy selection above' })

-- Moving windows more better
vim.keymap.set('n', '<C-w><C-w>', '<Cmd>WinShift swap<CR>', { desc = 'Swap [w]indow' })
vim.keymap.set('n', '<C-w><C-Left>', '<Cmd>WinShift left<CR>', { desc = 'Swap window <Left>' })
vim.keymap.set('n', '<C-w><C-Right>', '<Cmd>WinShift right<CR>', { desc = 'Swap window <Right>' })
vim.keymap.set('n', '<C-w><C-Up>', '<Cmd>WinShift up<CR>', { desc = 'Swap window <Up>' })
vim.keymap.set('n', '<C-w><C-Down>', '<Cmd>WinShift down<CR>', { desc = 'Swap window <Down>' })
vim.keymap.set('n', '<C-S-w><C-S-Left>', '<Cmd>WinShift far_left<CR>', { desc = 'Swap window far <LEFT>' })
vim.keymap.set('n', '<C-S-w><C-S-Right>', '<Cmd>WinShift far_right<CR>', { desc = 'Swap window far <RIGHT>' })
vim.keymap.set('n', '<C-S-w><C-S-Up>', '<Cmd>WinShift far_up<CR>', { desc = 'Swap window far <UP>' })
vim.keymap.set('n', '<C-S-w><C-S-Down>', '<Cmd>WinShift far_down<CR>', { desc = 'Swap window far <DOWN>' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true, silent = true })
vim.keymap.set('n', 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Miscellaneous
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<C-s>', '<cmd>w<cr>', { desc = '[S]ave' })

--[[ Line numbers ]]
vim.keymap.set({ 'n', 'v' }, '<leader>ll', function()
  local state = vim.o.number
  vim.o.number = not state
  vim.o.relativenumber = state
end, {
  desc = 'toggle [l]ine number mode'
})

vim.keymap.set({ 'n', 'v' }, '<leader>la', function()
  vim.o.number = not vim.o.number
end, {
  desc = 'toggle [a]bsolute line numbers'
})

vim.keymap.set({ 'n', 'v' }, '<leader>lr', function()
  vim.o.relativenumber = not vim.o.relativenumber
end, {
  desc = 'toggle [r]elative line numbers'
})

vim.keymap.set({ 'n', 'v' }, '<leader>lh', function()
  local state = not vim.o.relativenumber
  vim.o.number = state
  vim.o.relativenumber = state
end, {
  desc = 'toggle [h]ybrid line numbers'
})

--[[ Telescope bindings ]]
---@source ./config/telescope/init.lua
require('config.telescope.binds')

--[[ LSP bindings ]]
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
  ---@diagnostic disable-next-line: undefined-global
    vim.keymap.set(modes, keys, func, { buffer = bufnr, desc = desc })
  end

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

--[[ Mini.map bindings ]]
local MiniMap = require('mini.map')
vim.keymap.set('n', '<Leader>mm', MiniMap.toggle , { desc = '[M]ini.[m]ap toggle'  })
vim.keymap.set('n', '<Leader>mo', MiniMap.open   , { desc = '[M]ini.map [o]pen'    })
vim.keymap.set('n', '<Leader>mc', MiniMap.close  , { desc = '[M]ini.map [c]lose' })
vim.keymap.set('n', '<Leader>mr', MiniMap.refresh, { desc = '[M]ini.map [r]efresh' })
MiniMap.open()

--[[ (TODO) Splitjoin bindings ]]
-- gS -> Split
-- gJ -> Join

--[[ Hydra bindings ]]
---@source ./config/hydra/init.lua
require('config.hydra')

--[[ which-key ]]
---@source ./config/hydra/init.lua
require('config.which_key')

