local ts_parsers = require("nvim-treesitter.parsers")
local get_hygen_subext = require("hygen.utils").get_hygen_subext

local M = {}

-- see changed features in treesitter section
-- https://neovim.io/doc/user/news-0.10.html#_changed-features
local has_v_0_10 = vim.fn.has("nvim-0.10") == 1
local directive_options = has_v_0_10 and {} or nil
local ext_to_ft = {
  ts = "typescript",
}

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
      local subext = get_hygen_subext(bufnr)
      if subext == nil then
        return
      end

      local filetype = vim.filetype.match({ filename = "name." .. subext })
      local parser =
        ts_parsers.ft_to_lang(ext_to_ft[subext] or filetype or subext)

      metadata["injection.language"] = parser
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    directive_options
  )

  vim.treesitter.query.add_directive(
    "inject-hygen-ejs!",
    function(_, _, bufnr, _, metadata)
      if get_hygen_subext(bufnr) == nil then
        return
      end

      metadata["injection.language"] = "embedded_template"
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    directive_options
  )

  vim.treesitter.query.add_directive(
    "inject-embedded_template!",
    function(_, _, bufnr, _, metadata)
      local filename = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))

      if get_hygen_subext(filename) ~= nil then
        metadata["injection.language"] = "javascript"
        return
      end

      local ext = vim.fn.fnamemodify(filename, ":e")

      if ext == "ejs" then
        metadata["injection.language"] = "javascript"
      elseif ext == "erb" then
        metadata["injection.language"] = "ruby"
      end
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    directive_options
  )
end

return M
