local get_hygen_subext = require("hygen.utils").get_hygen_subext

local ext_to_ft = {
  ts = "typescript",
}

---@type table<string, TSDirective>
local directives = {
  ["inject-hygen-tmpl!"] = function(_, _, src, _, metadata)
    -- NOTE: should handle if source is a string? i.e. extract target parser
    -- from `to:` property
    if type(src) ~= "number" then
      return
    end

    local filename = vim.fs.basename(vim.api.nvim_buf_get_name(src))
    local subext = get_hygen_subext(filename)
    local filetype = vim.filetype.match({
      filename = vim.fn.fnamemodify(filename, ":t:r"),
    })

    if subext == nil then
      return
    end

    local parser =
      vim.treesitter.language.get_lang(filetype or ext_to_ft[subext] or subext)

    -- NOTE: notify about the parser not found?
    if parser ~= nil then
      metadata["injection.language"] = parser
    end
  end,
  ["inject-hygen-ejs!"] = function(_, _, src, _, metadata)
    -- NOTE: should handle if source is a string?
    if type(src) ~= "number" then
      return
    end

    if get_hygen_subext(src) == nil then
      return
    end

    metadata["injection.language"] = "embedded_template"
  end,
  ["inject-embedded_template!"] = function(_, _, src, _, metadata)
    -- NOTE: should handle if source is a string?
    if type(src) ~= "number" then
      return
    end

    local filename = vim.fs.basename(vim.api.nvim_buf_get_name(src))

    if get_hygen_subext(filename) ~= nil then
      metadata["injection.language"] = "javascript"
      return
    end

    local ext = vim.fn.fnamemodify(filename, ":e")

    if ext == "ejs" or vim.bo[src].filetype == "ejs" then
      metadata["injection.language"] = "javascript"
    elseif ext == "erb" or vim.bo[src].filetype == "eruby" then
      metadata["injection.language"] = "ruby"
    end
  end,
}

local function setup()
  local predicate_options = require("hygen.compat").predicate_options

  for name, handler in pairs(directives) do
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.treesitter.query.add_directive(name, handler, predicate_options)
  end
end

return { setup = setup }
