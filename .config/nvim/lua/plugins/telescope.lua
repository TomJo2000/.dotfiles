---@see telescope and telescope.setup
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
})

---@see telescope.builtin
local Telescope = require('telescope.builtin')

local M = {}

-- stylua: ignore
M.binds = {
  { 'n', '<leader>?'      , Telescope.oldfiles     , { desc = '[?] Find recently opened files' } },
  { 'n', '<leader><space>', Telescope.buffers      , { desc = '[ ] Find existing buffers' }      },
  { 'n', '<leader>sf'     , Telescope.find_files   , { desc = '[S]earch [F]iles' }               },
  { 'n', '<leader>sh'     , Telescope.help_tags    , { desc = '[S]earch [H]elp' }                },
  { 'n', '<leader>sw'     , Telescope.grep_string  , { desc = '[S]earch current [W]ord' }        },
  { 'n', '<leader>sg'     , Telescope.live_grep    , { desc = '[S]earch by [G]rep' }             },
  { 'n', '<leader>sG'     , ':LiveGrepGitRoot<cr>' , { desc = '[S]earch by [G]rep on Git Root' } },
  { 'n', '<leader>sd'     , Telescope.diagnostics  , { desc = '[S]earch [D]iagnostics' }         },
  { 'n', '<leader>sr'     , Telescope.resume       , { desc = '[S]earch [R]esume' }              },
  { 'n', '<leader>sk'     , Telescope.keymaps      , { desc = '[S]how [K]eymaps' }               },
  { 'n', '<leader>ca'     , vim.lsp.buf.code_action, { desc = 'LSP: [C]ode [A]ction' } },
  { 'n', '<leader>/'      , function()
    Telescope.current_buffer_fuzzy_find(
      require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = false,
      })
    )
  end, { desc = '[/] Fuzzily search in current buffer' } },
  { 'n', 'gd', Telescope.lsp_definitions, { desc = 'LSP: [G]oto [D]efinition' } },
  { 'n', 'gr', Telescope.lsp_references, { desc = 'LSP: [G]oto [R]eferences' } },
  { 'n', 'gI', Telescope.lsp_implementations, { desc = 'LSP: [G]oto [I]mplementation' } },
  { 'n', '<leader>D', Telescope.lsp_type_definitions, { desc = 'LSP: Type [D]efinition' } },
  { 'n', '<leader>ds', Telescope.lsp_document_symbols, { desc = 'LSP: [D]ocument [S]ymbols' } },
  { 'n', '<leader>ws', Telescope.lsp_dynamic_workspace_symbols, { desc = 'LSP: [W]orkspace [S]ymbols' } },

  -- See `:help K` for why this keymap
  { 'n', 'K', vim.lsp.buf.hover, { desc = 'LSP: Hover Documentation' } },
  { 'n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'LSP: Signature Documentation' } },

  -- Lesser used LSP functionality
  { 'n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP: [G]oto [D]eclaration' } },
  { 'n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = 'LSP: [W]orkspace [A]dd Folder' } },
  { 'n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = 'LSP: [W]orkspace [R]emove Folder' } },
  { 'n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { desc = 'LSP: [W]orkspace [L]ist Folders'} },
}

return M

--[[ stuff I still need to look into

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
--]]
