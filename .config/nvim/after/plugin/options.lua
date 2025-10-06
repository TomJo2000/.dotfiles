-- 24Bit color
vim.o.termguicolors = true

-- Set the window title
vim.o.title = true

-- Show whitespace using the characters in listchars
vim.wo.list = true

-- Whitespace symbols
vim.opt.listchars = {
  space = '∙',
  tab = '› ',
  trail = '◦',
  extends = '»',
  precedes = '«',
  nbsp = '°',
}

vim.o.tabstop = 4
vim.o.expandtab = true

-- Don't show search count message,
-- it's capped at 99 so we do it in lualine instead
vim.o.shortmess = vim.o.shortmess .. 'S'

-- Make (absolute) line numbers default
vim.wo.number = true

-- We handle these in lualine instead of an extra line under the statusline
vim.o.showmode = false -- Don't show the mode
vim.o.showcmd = true -- Show commands

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Indent wrapped lines to the same level as the start of the line
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

-- Enable highlighting the current line
vim.o.cursorline = true
vim.o.cursorlineopt = 'screenline'

-- Ask for confirmation when quitting an unsaved buffer instead of refusing
vim.o.confirm = true

-- Set defaults for splits
vim.o.splitright = true -- :vs[plit] opens to the right
vim.o.splitbelow = true -- :sp[lit] opens below
