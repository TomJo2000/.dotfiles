local M = {}

M.config = {
  -- stylua: ignore
  formatters_by_ft = {
    lua  = { 'stylua' },
    just = { 'just' },
    zig  = { 'zigfmt' },
    -- Use the "*" filetype to run formatters on all filetypes.
    ['*'] = { 'codespell' },
    -- Use the "_" filetype to run formatters on filetypes that don't
    -- have other formatters configured.
    ['_'] = { 'trim_whitespace' },
  },
  -- If this is set, Conform will run the formatter on save.
  -- It will pass the table to conform.format().
  -- This can also be a function that returns the table.
  format_on_save = {
    -- I recommend these options. See :help conform.format for details.
    lsp_fallback = true,
    timeout_ms = 500,
  },
  -- Set the log level. Use `:ConformInfo` to see the location of the log file.
  log_level = vim.log.levels.ERROR,
  -- Conform will notify you when a formatter errors
  notify_on_error = true,
}

return M
