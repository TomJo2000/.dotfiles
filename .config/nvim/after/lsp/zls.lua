local M = {}

---@see schema.json
---|https://github.com/zigtools/zls/blob/master/schema.json
M.settings = {
  zls = {
    highlight_global_var_declarations = true,
    inlay_hints_exclude_single_argument = false,
    warn_style = true,
  },
}

return M
