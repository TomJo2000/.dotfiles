-- [[ setup keybinds ]]

-- [[ Basic keybinds ]]
-- Moving lines
vim.keymap.set('n', '<M-Down>', 'ddp', { desc = 'Swap line down' })
vim.keymap.set('n', '<M-Up>', 'ddkP', { desc = 'Swap line up' })
vim.keymap.set('n', '<M-C-Down>', 'yyp', { desc = 'Copy line below' })
vim.keymap.set('n', '<M-C-Up>', 'yyP', { desc = 'Copy line above' })
vim.keymap.set('v', '<M-Down>', 'yjp', { desc = 'Copy selection below' })
vim.keymap.set('v', '<M-Up>', 'yyp', { desc = 'Copy selection above' })

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

-- Line numbers
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

-- Miscellaneous
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<C-s>', '<cmd>w<cr>', { desc = '[S]ave' })

-- [[ Telescope bindings ]]
---@see telescope and telescope.setup
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

---@see telescope.builtin
local Telescope = require('telescope.builtin')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print('Not a git repository. Searching on current working directory')
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = { git_root },
    })
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  Telescope.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>?', Telescope.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', Telescope.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>gf', Telescope.git_files, { desc = '[G]it [F]ile search' })
vim.keymap.set('n', '<leader>sf', Telescope.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', Telescope.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', Telescope.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', Telescope.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', Telescope.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', Telescope.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>sk', Telescope.keymaps, { desc = '[S]how [K]eymaps' })

-- [[ LSP bindings ]]
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

  lsp_map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
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

-- [[ Mini.map bindings ]]
local MiniMap = require('mini.map')
vim.keymap.set('n', '<Leader>mm', MiniMap.toggle, { desc = '[M]ini.[m]ap toggle' })
vim.keymap.set('n', '<Leader>mo', MiniMap.open, { desc = '[M]ini.map [o]pen' })
vim.keymap.set('n', '<Leader>mc', MiniMap.close, { desc = '[M]ini.map [c]lose' })
vim.keymap.set('n', '<Leader>mr', MiniMap.refresh, { desc = '[M]ini.map [r]efresh' })
MiniMap.open()

-- [[ Hydra bindings ]]
---@source ./config/hydra/init.lua
require('config.hydra')

-- [[ which-key ]]
-- document existing key chains
require('which-key').register {
  ['<leader>c']  = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d']  = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g']  = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>gh'] = { name = '[G]it [h]unks', _ = 'which_key_ignore' },
  ['<leader>r']  = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s']  = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>w']  = { name = '[W]orkspace', _ = 'which_key_ignore' },
  -- my key chains
  ['<leader>l']  = { name = '[L]ine numbers', _ = 'which_key_ignore' },
  ['<leader>m']  = { name = '[M]ini.map', _ = 'which_key_ignore' },
}

