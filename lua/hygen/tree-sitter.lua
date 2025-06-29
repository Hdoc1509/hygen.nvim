local ts_parsers = require("nvim-treesitter.parsers")

---@class hygen.treesitter.injection.Config
---@field bash? boolean Enables `embedded_template` injection for `bash` parser
---@field markdown_inline? boolean Enables `embedded_template` injection for `markdown_inline` parser

---@class hygen.treesitter.Config
---@field injection? hygen.treesitter.injection.Config Additional injections

local M = {}

-- see changed features in treesitter section
-- https://neovim.io/doc/user/news-0.10.html#_changed-features
local has_v_0_10 = vim.fn.has("nvim-0.10") == 1
local directive_options = has_v_0_10 and {} or nil
local ext_to_ft = {
  ts = "typescript",
}

---@type hygen.treesitter.Config
local default_config = {
  injection = {
    bash = true,
    markdown_inline = true,
  },
}

---@param config? hygen.treesitter.Config
function M.setup(config)
  config = vim.tbl_deep_extend("force", default_config, config or {})

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

      local _, _, ext = string.find(filename, ".*%.(%a+)(%.%a+)")
      local filetype = vim.filetype.match({ filename = "name." .. ext })

      local parsed_ft = ext_to_ft[ext] or filetype

      -- filetype can be nil
      local parser_found = ts_parsers.ft_to_lang(parsed_ft or ext)

      metadata["injection.language"] = parser_found
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    directive_options
  )

  vim.treesitter.query.add_directive(
    "inject-hygen-bash-ejs!",
    function(_, _, bufnr, _, metadata)
      if not config.injection.bash then
        return
      end

      local filename = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
      local _, _, subext, ext = string.find(filename, ".*%.(%a+)(%.%a+)")

      if subext == nil or ext ~= ".hygen" then
        return
      end

      metadata["injection.language"] = "embedded_template"
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    directive_options
  )

  vim.treesitter.query.add_directive(
    "inject-hygen-markdown_inline-ejs!",
    function(_, _, bufnr, _, metadata)
      if not config.injection.markdown_inline then
        return
      end

      local filename = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
      local _, _, subext, ext = string.find(filename, ".*%.(%a+)(%.%a+)")

      if subext == nil or ext ~= ".hygen" then
        return
      end

      metadata["injection.language"] = "embedded_template"
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    directive_options
  )
end

return M
