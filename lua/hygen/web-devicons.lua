local devicons = require("nvim-web-devicons")

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

---Returns the icon from subextension and hygen color
---Fallbacks to `devicons.get_icon_color()` if subextension is not `hygen` file
---@param filename string
---@return string icon, string color
function M.get_icon(filename)
  local extension = vim.fn.fnamemodify(filename, ":e")

  if extension == "hygen" then
    local _, _, subext, hygen_ext = string.find(filename, ".*%.(%a+)(%.%a+)")

    if subext == nil or hygen_ext ~= ".hygen" then
      return devicons.get_icon_color(filename, extension)
    end

    local icon = devicons.get_icon("name." .. subext, subext)

    return icon, main_color
  else
    return devicons.get_icon_color(filename, extension)
  end
end

return M
