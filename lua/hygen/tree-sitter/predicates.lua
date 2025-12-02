---@type table<string, TSPredicate>
local predicates = {
  ["has-hygen-from-key?"] = function(match, _, bufnr, pred)
    local filename = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
    local ext = vim.fn.fnamemodify(filename, ":e")

    if ext ~= "hygen" then
      return
    end

    local frontmatter_capture_id = pred[2]
    local frontmatter_node = match[frontmatter_capture_id]

    if frontmatter_node == nil then
      return false
    end

    local frontmatter_text =
      vim.treesitter.get_node_text(frontmatter_node, bufnr)

    return string.match(frontmatter_text, "\nfrom:") ~= nil
  end,
}

local function setup()
  local predicate_options = require("hygen.compat").predicate_options

  for name, handler in pairs(predicates) do
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.treesitter.query.add_predicate(name, handler, predicate_options)
  end
end

return { setup = setup }
