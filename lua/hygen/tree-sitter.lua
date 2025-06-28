local ts_parsers = require("nvim-treesitter.parsers")

local has_v_0_10 = vim.fn.has("nvim-0.10") == 1
local directive_options = nil
local ext_to_ft = {
  ts = "typescript",
}

-- see changed features in treesitter section
-- https://neovim.io/doc/user/news-0.10.html#_changed-features
if has_v_0_10 then
  directive_options = {}
end

local M = {}

function M.setup()
  --- @class ParserConfig
  local parser_config = ts_parsers.get_parser_configs()

  parser_config.hygen_template = {
    install_info = {
      url = "https://github.com/Hdoc1509/tree-sitter-hygen-template",
      files = { "src/parser.c" },
      generate_requires_npm = true,
      revision = "release",
    },
    filetype = "hygen",
  }

  -- register directive
  vim.treesitter.query.add_directive(
    "inject-hygen-tmpl!",
    function(_, _, bufnr, _, metadata)
      local filename = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))

      local _, _, ext, _ = string.find(filename, ".*%.(%a+)(%.%a+)")
      local filetype = vim.filetype.match({ filename = "name." .. ext })

      local parsed_ft = ext_to_ft[ext] or filetype

      -- filetype can be nil
      local parser_found = ts_parsers.ft_to_lang(parsed_ft or ext)

      metadata["injection.language"] = parser_found
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    directive_options
  )
end

return M
