local M = {}

-- https://github.com/jondot/hygen/blob/master/hygen.io/src/css/custom.css#L9
local main_color = "#f722b1"

-- TODO: add get_icon() function
-- similar to hygen-compatible() function from my nvim-config

function M.setup()
  local devicons = require("nvim-web-devicons")

  devicons.set_icon({
    hygen = {
      icon = "", -- same as `ejs`
      color = main_color,
      name = "Hygen",
    },
  })
  devicons.set_icon_by_filetype({ hygen_template = "hygen" })
end

return M
