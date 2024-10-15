local M = {}

-- https://github.com/jondot/hygen/blob/master/hygen.io/src/css/custom.css#L9
local main_color = "#f722b1"

function M.setup()
  require("nvim-web-devicons").set_icon({
    hygen = {
      icon = "", -- same as `ejs`
      color = main_color,
      name = "Hygen",
    },
  })
end

return M
