local M = {}

---@see formatter-options.html
---|https://taplo.tamasfe.dev/configuration/formatter-options.html
M.settings = {
  formatter = {
    align_entries = false,
    align_comments = false,
    -- array_trailing_comma = true,
    -- array_auto_expand = true,
    array_auto_collapse = false,
    compact_arrays = false,
    -- compact_inline_tables = false,
    -- inline_table_expand = true,
    -- compact_entries = false,
    column_width = 160,
    indent_tables = true,
    indent_entries = true,
    indent_string = 2,
    trailing_newline = false,
    -- reorder_keys = false,
    -- reorder_arrays = false,
    -- reorder_inline_tables = false,
    -- allowed_blank_lines = 2,
    -- crlf = false,
  },
}

return M
