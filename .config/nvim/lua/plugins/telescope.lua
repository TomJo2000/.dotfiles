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
