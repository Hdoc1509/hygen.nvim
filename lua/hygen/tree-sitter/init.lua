local M = {}

function M.setup()
  require("hygen.tree-sitter.parser-info").setup()
  require("hygen.tree-sitter.predicates").setup()
  require("hygen.tree-sitter.directives").setup()
end

return M
