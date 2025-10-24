--- (ACK) Adapted from:
--- https://github.com/jdhao/nvim-config/blob/360513d3b7ef268c42450081f33917f934a3de1a/lua/config/nvim_ufo.lua

M = {}

---@class UfoFoldVirtTextHandlerContext
---@field bufnr number buffer for closed fold
---@field winid number window for closed fold
---@field text string text for the first line of closed fold
---@field get_fold_virt_text fun(lnum: number): UfoExtmarkVirtTextChunk[] a function to get virtual text by lnum

---@class UfoExtmarkVirtTextChunk
---@field [1] string text
---@field [2] string|number highlight

---@param virt_text UfoExtmarkVirtTextChunk[] contained text and highlight captured by Ufo, export to caller
---@param start_line number first line of closed fold, like `v:foldstart` in `foldtext()`
---@param end_line number last line of closed fold, like `v:foldend` in `foldtext()`
---@param width number text area width, excluding `foldcolumn`, `signcolumn` and `numberwidth`
---@param truncate fun(str: string, width: number): string truncate the `str` to become specific width,
---@param ctx UfoFoldVirtTextHandlerContext the context used by ufo, export to caller (unused in this implementation)
---@return UfoExtmarkVirtTextChunk[]
---@diagnostic disable-next-line: unused-local ctx is available, but unused in this handler
M.fold_virt_text_handler = function(virt_text, start_line, end_line, width, truncate, ctx)
  local virt_text_out = {}
  local folded_lines = end_line - start_line
  local suffix = ('  ❮%d lines❯'):format(folded_lines)
  local suffix_width = vim.fn.strdisplaywidth(suffix)
  local target_width = width - suffix_width
  local current_width = 0

  for _, chunk in ipairs(virt_text) do
    local chunk_text = chunk[1]
    local chunk_width = vim.fn.strdisplaywidth(chunk_text)
    if target_width > current_width + chunk_width then
      table.insert(virt_text_out, chunk)
    else
      chunk_text = truncate(chunk_text, target_width - current_width)
      local hlGroup = chunk[2]
      table.insert(virt_text_out, { chunk_text, hlGroup })
      chunk_width = vim.fn.strdisplaywidth(chunk_text)

      if current_width + chunk_width < target_width then
        suffix = suffix .. (' '):rep(target_width - current_width - chunk_width)
      end
      break
    end
    current_width = current_width + chunk_width
  end
  local right_pad = math.max(math.min(vim.o.textwidth, width - 1) - current_width - suffix_width, 0)
  suffix = (' '):rep(right_pad) .. suffix
  table.insert(virt_text_out, { suffix, 'Delimiter' })
  return virt_text_out
end

return M
