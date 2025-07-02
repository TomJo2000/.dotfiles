M = {}

---@see settings.md
---|https://go.googlesource.com/tools/+/refs/heads/master/gopls/doc/settings.md
M.settings = {
  gopls = {
    -- formatting = {
    --   local = `go list -m`
    -- }
    -- Completion
    usePlaceholders = true,
  },
}

return M
