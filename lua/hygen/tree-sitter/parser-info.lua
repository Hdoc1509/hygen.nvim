---@param opts Hygen.TS.Opts
local function setup(opts)
  local ts_parsers = require("nvim-treesitter.parsers")

  local install_info = {
    url = opts.path or opts.url,
    path = opts.path,
    -- compatibility prior to removal of `files` option:
    -- https://github.com/nvim-treesitter/nvim-treesitter/commit/214cfcf851d95a4c4f2dc7526b95ce9d31c88a76
    files = { "src/parser.c" },
    -- compatibility prior to removal of `generate_requires_npm` option:
    -- https://github.com/nvim-treesitter/nvim-treesitter/commit/5a38df5627fd0658223bdf32c9d6a87e32eb9504
    generate_requires_npm = true,
    -- compatibility prior to default generate from json:
    -- https://github.com/nvim-treesitter/nvim-treesitter/commit/bdc2e01958209dea64fc1a8b7dbf34d0dd96930e
    generate_from_json = true,
    revision = opts.revision,
    generate = opts.from_grammar,
    --compatibility prior to disuse of `requires_generate_from_grammar` option:
    -- https://github.com/nvim-treesitter/nvim-treesitter/commit/c70daa36dcc2fdae113637fba76350daaf62dba5
    requires_generate_from_grammar = opts.from_grammar,
  }
  local parser_info = {
    install_info = install_info,
    maintainers = { "@Hdoc1509" },
    -- NOTE: because grammar is not stable enough. a breaking change is expected
    -- set `tier = 1` once parser include wasm artifacts in its releases?
    tier = 3,
    filetype = "hygen",
  }

  if ts_parsers.get_parser_configs ~= nil then
    -- old `master` branch
    local parser_configs = ts_parsers.get_parser_configs()
    ---@diagnostic disable-next-line: inject-field
    parser_configs.hygen_template = parser_info
  elseif ts_parsers.configs ~= nil then
    -- reference: https://github.com/nvim-treesitter/nvim-treesitter/commit/692b051b09935653befdb8f7ba8afdb640adf17b
    ts_parsers.configs.hygen_template = parser_info
    vim.treesitter.language.register("hygen_template", "hygen")
  else
    -- reference: https://github.com/nvim-treesitter/nvim-treesitter/commit/c17de5689045f75c6244462182ae3b4b62df02d9
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        require("nvim-treesitter.parsers").hygen_template = parser_info
      end,
    })
    vim.treesitter.language.register("hygen_template", "hygen")
  end
end

return { setup = setup }
