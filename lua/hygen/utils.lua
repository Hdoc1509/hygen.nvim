local M = {}

local not_allowed_subext = { "ejs", "erb", "hygen" }

---@param file string | number Filename or buffer number
---@return string | nil subext Subextension if file matched naming convention
function M.get_hygen_subext(file)
  local filename = type(file) == "number"
      and vim.fs.basename(vim.api.nvim_buf_get_name(file))
    or file
  local subext = string.match(filename, ".*%.(%a+)%.hygen")

  if subext == nil or vim.tbl_contains(not_allowed_subext, subext) then
    return
  end

  return subext
end

return M
