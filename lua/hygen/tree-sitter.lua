local ts_parsers = require("nvim-treesitter.parsers")
local get_hygen_subext = require("hygen.utils").get_hygen_subext

---@class hygen.treesitter.injection.Config
---@field bash? boolean Enables `embedded_template` injection for `bash` parser
---@field markdown_inline? boolean Enables `embedded_template` injection for `markdown_inline` parser
---@field html? boolean Enables `embedded_template` injection for `html` parser

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
    html = true,
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
      local subext = get_hygen_subext(bufnr)
      -- stylua: ignore
      if subext == nil then return end

      local filetype = vim.filetype.match({ filename = "name." .. subext })
      local parser =
        ts_parsers.ft_to_lang(ext_to_ft[subext] or filetype or subext)

      metadata["injection.language"] = parser
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    directive_options
  )

  -- TODO: add `inject-hygen-ejs-to!` directive
  -- remove `inject-hygen-[bash|markdown_inline|html]-ejs!` directives. these
  -- should be manually added to custom queries of usuers
  -- NOTE: this will inject `embedded_template`, but its `injection` query uses
  -- `ruby` instead of `javascript`. will it require to use a custom directive
  -- to only inject `javascript` to `.ejs` and `.subext.hygen` files and `ruby`
  -- for the rest?

  vim.treesitter.query.add_directive(
    "inject-hygen-bash-ejs!",
    function(_, _, bufnr, _, metadata)
      if not config.injection.bash or get_hygen_subext(bufnr) == nil then
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
      if
        not config.injection.markdown_inline or get_hygen_subext(bufnr) == nil
      then
        return
      end

      metadata["injection.language"] = "embedded_template"
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    directive_options
  )

  vim.treesitter.query.add_directive(
    "inject-hygen-html-ejs!",
    function(_, _, bufnr, _, metadata)
      if not config.injection.html or get_hygen_subext(bufnr) == nil then
        return
      end

      metadata["injection.language"] = "embedded_template"
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    directive_options
  )

  vim.treesitter.query.add_directive(
    "highlight-increase-ejs-priority!",
    function(_, _, bufnr, _, metadata)
      if get_hygen_subext(bufnr) == nil then
        return
      end

      metadata.priority = 130
    end,
    ---@diagnostic disable-next-line: param-type-mismatch
    directive_options
  )
end

return M
