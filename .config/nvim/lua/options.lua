-- Whitespace symbols
vim.opt.listchars = {
  space = '∙',
  tab = '░ ',
  trail = '◦',
  extends = '»',
  precedes = '«',
  nbsp = '°'
}
vim.o.list = true

vim.o.tabstop = 4
vim.o.expandtab = true

-- Set highlight on search
vim.o.hlsearch = false

-- Make (absolute) line numbers default
vim.wo.number = true

-- toggle between absolute and relative line numbers with <leader>ll
vim.keymap.set({ 'n', 'v' }, '<leader>ll', function()
  local state = vim.o.number
  vim.o.number = not state
  vim.o.relativenumber = state
end, { desc = 'toggle [l]ine number mode' })

vim.keymap.set({ 'n', 'v' }, '<leader>la', function()
  vim.o.number = not vim.o.number
end, { desc = 'toggle [a]bsolute line numbers' })

vim.keymap.set({ 'n', 'v' }, '<leader>lr', function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = 'toggle [r]elative line numbers' })

vim.keymap.set({ 'n', 'v' }, '<leader>lh', function()
  local state = not vim.o.relativenumber
  vim.o.number = state
  vim.o.relativenumber = state
end, { desc = 'toggle [h]ybrid line numbers' })

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

