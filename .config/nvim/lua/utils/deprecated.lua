local nvim_version = { vim.version().major, vim.version().minor, vim.version().patch }

--- ### Check if version is greater or equal to the given one
---@param since string|number[]|vim.Version # version since which the function is deprecated
---@return boolean # true if the function is deprecated in the current version
return function(since)
  return vim.version.ge(nvim_version, since)
end
