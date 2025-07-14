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

--Returns the `icon` from subextension, hygen `color` and `highlight` group.
--Fallbacks to `devicons` utilities if `filename` does not match naming
--convention
---@param filename string
---@param opts? { fullpath?: string, bufnr?: number}
---@return string icon, string color, string? hl
function M.get_icon(filename, opts)
  opts = opts or {}

  local subext = get_hygen_subext(filename)
  local ext = vim.fn.fnamemodify(filename, ":e")

  -- TODO: improve this. reduce indentations

  if subext == nil and ext ~= "hygen" then
    local initial_icon, initial_color = devicons.get_icon_color(filename, ext)

    if initial_icon ~= nil and initial_color ~= nil then
      return initial_icon, initial_color
    end

    if ext == "" then
      local filetype = "unknown"

      if type(opts.bufnr) == "number" then
        filetype = vim.bo[opts.bufnr].filetype
      elseif type(opts.fullpath) == "string" then
        ---@type string[]
        local first_line = vim.fn.readfile(opts.fullpath, "", 1)

        if #first_line > 0 then
          local shell_bin_hash = first_line[1]:match("^#!/bin/(%w+)")

          if shell_bin_hash ~= nil then
            filetype = shell_bin_hash
          else
            local shell_usr_bin_env_hash =
              first_line[1]:match("^#!/usr/bin/env (%w+)")

            if shell_usr_bin_env_hash ~= nil then
              filetype = shell_usr_bin_env_hash
            else
              local ft_modeline = first_line[1]:match(".*vim:.*ft=(%w+)")

              if ft_modeline ~= nil then
                filetype = ft_modeline
              end
            end
          end
        end
      end

      local icon, color =
        devicons.get_icon_color_by_filetype(filetype, { default = true })
      local _, hl = devicons.get_icon_by_filetype(filetype, { default = true })

      return icon, color, hl
    end

    return initial_icon, initial_color
  end

  local target_name = vim.fn.fnamemodify(filename, ":t:r")
  local icon =
    devicons.get_icon(target_name, vim.fn.fnamemodify(target_name, ":e"))

  if icon == nil then
    return devicons.get_icon_color(filename, ext)
  else
    return icon, main_color
  end
end

return M
