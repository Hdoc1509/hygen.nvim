local devicons = require("nvim-web-devicons")
local get_hygen_subext = require("hygen.utils").get_hygen_subext

local M = {}

-- https://github.com/jondot/hygen/blob/master/hygen.io/src/css/custom.css
-- `--ifm-color-primary`
local main_color = "#f722b1"

function M.setup()
  devicons.set_icon({
    hygen = {
      icon = "", -- same as `ejs`
      color = main_color,
      name = "Hygen",
    },
  })
  devicons.set_icon_by_filetype({ hygen_template = "hygen" })
end

--Returns the icon from subextension and hygen color
--Fallbacks to `devicons.get_icon_color()` if `filename` does not match
--naming convention
---@param filename string
---@return string icon, string color
function M.get_icon(filename)
  local subext = get_hygen_subext(filename)

  if subext == nil then
    return devicons.get_icon_color(filename, vim.fn.fnamemodify(filename, ":e"))
  end

  local icon = devicons.get_icon("name." .. subext, subext)

  return icon, main_color
end

return M
