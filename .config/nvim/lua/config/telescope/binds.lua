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

---@see telescope.builtin
local Telescope = require('telescope.builtin')

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
