local M = {}

---@class Hygen.TS.Opts
---Whether to `generate` files from the grammar before building it.
---@field from_grammar? boolean
---Path to local `tree-sitter-hygen-template`. If set, `url` and `revision` options are ignored.
---@field path? string
---Remote URL to `tree-sitter-hygen-template`.
---@field url? string
---Branch, tag or commit of `tree-sitter-hygen-template`.
---@field revision? string

---@type Hygen.TS.Opts
local default_opts = {
  url = "https://github.com/Hdoc1509/tree-sitter-hygen-template",
  revision = "v0.5.0",
}

---@param opts Hygen.TS.Opts
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  require("hygen.tree-sitter.parser-info").setup(opts)
  require("hygen.tree-sitter.directives").setup()
end

return M
