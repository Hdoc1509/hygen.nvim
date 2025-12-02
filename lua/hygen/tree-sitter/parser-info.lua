local function setup()
  local ts_parsers = require("nvim-treesitter.parsers")
  local parser_configs = ts_parsers.get_parser_configs()

  local install_info = {
    url = "https://github.com/Hdoc1509/tree-sitter-hygen-template",
    files = { "src/parser.c" },
    generate_requires_npm = true,
    revision = "release",
  }
  local parser_info = {
    install_info = install_info,
    filetype = "hygen",
  }

  ---@diagnostic disable-next-line: inject-field
  parser_configs.hygen_template = parser_info
end

return { setup = setup }
