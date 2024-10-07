local M = {}

function M.setup()
  require("nvim-web-devicons").set_icon({
    -- same as `ejs`
    hygen = {
      icon = "",
      color = "#cbcb41",
      name = "Hygen",
    },
  })
end

return M
