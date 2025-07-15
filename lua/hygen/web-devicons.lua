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

---Returns the `icon` from subextension, hygen `color` and `hl` group of `icon`
---Fallbacks to `nvim-web-devicons` if `filename` does not match naming
---convention
---@param filename string
---@return string icon, string color, string hl
function M.get_icon(filename)
  local subext = get_hygen_subext(filename)
  local ext = vim.fn.fnamemodify(filename, ":e")

  if subext == nil and ext ~= "hygen" then
    local icon, color =
      devicons.get_icon_color(filename, ext, { default = true })
    local _, hl = devicons.get_icon(filename, ext, { default = true })

    return icon, color, hl
  end

  local target_name = vim.fn.fnamemodify(filename, ":t:r")
  local initial_icon =
    devicons.get_icon(target_name, vim.fn.fnamemodify(target_name, ":e"))

  if initial_icon == nil then
    local icon, color = devicons.get_icon_color(filename, ext)
    local _, hl = devicons.get_icon(filename, ext, { default = true })

    return icon, color, hl
  else
    return initial_icon, main_color, "DevIconHygen"
  end
end

return M
