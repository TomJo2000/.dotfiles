-- setup keybinds
---@see nvim/init.lua

-- [[ Moving lines ]]
vim.keymap.set('n', '<M-Down>', 'ddp', { desc = 'Swap line down' })
vim.keymap.set('n', '<M-Up>', 'ddkP', { desc = 'Swap line up' })
vim.keymap.set('n', '<M-C-Down>', 'yyp', { desc = 'Copy line below' })
vim.keymap.set('n', '<M-C-Up>', 'yyP', { desc = 'Copy line above' })
vim.keymap.set('v', '<M-Down>', 'yjp', { desc = 'Copy selection below' })
vim.keymap.set('v', '<M-Up>', 'yyp', { desc = 'Copy selection above' })

-- [[ Save ]]
vim.keymap.set('n', '<C-s>', '<cmd>w<cr>', { desc = '[S]ave' })

-- [[ Moving windows more better ]]
vim.keymap.set('n', '<C-w><C-w>', '<Cmd>WinShift swap<CR>', { desc = 'Swap [w]indow' })
vim.keymap.set('n', '<C-w><C-Left>', '<Cmd>WinShift left<CR>', { desc = 'Swap window <Left>' })
vim.keymap.set('n', '<C-w><C-Right>', '<Cmd>WinShift right<CR>', { desc = 'Swap window <Right>' })
vim.keymap.set('n', '<C-w><C-Up>', '<Cmd>WinShift up<CR>', { desc = 'Swap window <Up>' })
vim.keymap.set('n', '<C-w><C-Down>', '<Cmd>WinShift down<CR>', { desc = 'Swap window <Down>' })
vim.keymap.set('n', '<C-S-w><C-S-Left>', '<Cmd>WinShift far_left<CR>', { desc = 'Swap window far <LEFT>' })
vim.keymap.set('n', '<C-S-w><C-S-Right>', '<Cmd>WinShift far_right<CR>', { desc = 'Swap window far <RIGHT>' })
vim.keymap.set('n', '<C-S-w><C-S-Up>', '<Cmd>WinShift far_up<CR>', { desc = 'Swap window far <UP>' })
vim.keymap.set('n', '<C-S-w><C-S-Down>', '<Cmd>WinShift far_down<CR>', { desc = 'Swap window far <DOWN>' })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
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

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
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

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local Telescope = require('telescope.builtin')

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

-- [[ Hydra bindings ]]
require('config.hydra')
