--# selene: allow(mixed_table)
-- BOOTSTRAP -- DO NOT CHANGE
local bootstrap_cmd =
  "curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"
vim.env.LAZY_STDPATH = "~/.repro/hygen.nvim"
load(vim.fn.system(bootstrap_cmd))()
-- BOOTSTRAP -- DO NOT CHANGE

-- NOTE: update config below to match your use case
require("lazy.minit").repro({
  spec = {
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      build = ":TSUpdate",
      dependencies = {
        {
          "Hdoc1509/hygen.nvim",
          -- branch = "branch",
          -- version = '*',
        },
      },
      config = function()
        require("hygen.tree-sitter").setup()

        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
          ensure_installed = {
            "hygen_template",
          },
          highlight = { enable = true },
        })
      end,
    },
  },
})
