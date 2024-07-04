local M = {}

---@see mini.surround
M.opts = { -- Module mappings. Use `''` (empty string) to disable one.
  -- stylua: ignore
  mappings = {
    add            = '', -- Add surrounding in Normal and Visual modes
    delete         = '', -- Delete surrounding
    find           = '', -- Find surrounding (to the right)
    find_left      = '', -- Find surrounding (to the left)
    highlight      = '', -- Highlight surrounding
    replace        = '', -- Replace surrounding
    update_n_lines = '', -- Update `n_lines`

    suffix_last    = '', -- Suffix to search with "prev" method
    suffix_next    = '', -- Suffix to search with "next" method
  },
}

return M
