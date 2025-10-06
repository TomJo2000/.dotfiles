local M = {}

M.opts = {
  formatters = {
    trim_whitespace = {
      inherit = true,
      condition = function(self, ctx)
        local ret = {
          diff = false,
          gitcommit = false,
          gitsendemail = false,
          help = false,
        }
        return ret[vim.bo[0].ft] == nil
      end,
    },
    retab = {
      meta = { description = 'Redo tabs' },
      format = function(self, ctx, lines, callback)
        local pos = vim.fn.winsaveview()
        vim.api.nvim_feedkeys('gg=G', 'n', true)
        vim.fn.winrestview(pos)
        vim.notify('Retabbed')
      end,
    },
  },
  formatters_by_ft = {
    go = { 'gofmt' },
    html = { 'retab' },
    just = { 'just' },
    lua = { 'stylua' },
    markdown = { 'retab' },
    query = { 'format-queries' },
    toml = { 'taplo' },
    zig = { 'zigfmt' },
    -- Use the "*" filetype to run formatters on all filetypes.
    ['*'] = { 'codespell', 'trim_whitespace' },
  },
  -- If this is set, Conform will run the formatter on save.
  -- It will pass the table to conform.format().
  -- This can also be a function that returns the table.
  format_on_save = {
    lsp_fallback = false,
    timeout_ms = 500,
  },
  -- Set the log level. Use `:ConformInfo` to see the location of the log file.
  log_level = vim.log.levels.ERROR,
  -- Conform will notify you when a formatter errors
  notify_on_error = true,
}

return M
