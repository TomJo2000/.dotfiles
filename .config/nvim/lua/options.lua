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

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
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

-- Enable highlighting the current line
vim.o.cursorline = true
vim.o.cursorlineopt = 'screenline'

-- Ask for confirmation when quiting an unsaved buffer instead of refusing
vim.o.confirm = true

-- Set defaults for splits
vim.o.splitright = true -- :vs[plit] opens to the right
vim.o.splitbelow = true -- :sp[lit] opens below


