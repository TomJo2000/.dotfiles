local nvim_version = { vim.version().major, vim.version().minor, vim.version().patch }

--- ### Check if version is greater or equal to the given one
---@param since string|number[]|vim.Version # version since which the function is deprecated
---@return boolean # true if the function is deprecated in the current version
return function(since)
  -- stylua: ignore
  return vim.version.ge
  and vim.version.ge(nvim_version, since) or  -- vim.version.ge is from Neovim 0.10.0
  not vim.version.lt(nvim_version, since)     -- vim.version.lt is from Neovim 0.9.0
end
