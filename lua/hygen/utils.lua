local M = {}

---@param file string | number Filename or buffer number
---@return string | nil subext Subextension if file matched naming convention
function M.get_hygen_subext(file)
  local filename = type(file) == "number"
      and vim.fs.basename(vim.api.nvim_buf_get_name(file))
    or file
  local _, _, subext, hygen_ext = string.find(filename, ".*%.(%a+)(%.%a+)")

  if subext == nil or hygen_ext ~= ".hygen" then
    return
  end

  return subext
end

return M
