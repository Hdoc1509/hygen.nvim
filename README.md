<!-- markdownlint-disable MD033 -->

# hygen.nvim

Neovim plugin that integrates [`tree-sitter-hygen-template`][hygen-template]
to provide syntax highlighting for [Hygen](https://www.hygen.io/) templates.

![Hygen template with Markdown parser injected](https://github.com/user-attachments/assets/e0357098-d9f4-4bee-9a9d-982cc682f02d)

> [!NOTE]
> See [integrations](#integrations) section to learn how to integrate
> `hygen.nvim` with other plugins.

## Features

- Syntax highlighting for [Hygen](https://www.hygen.io/) templates.
- Dynamic parser injection based on file extension (see [dynamic injection](#dynamic-injection))
- [New directive](#inject-hygen-ejs-directive) to customize injections
- Utility to get [hygen-ed colored icons](#hygen-ed-colored-icons)

## Requirements

- `Neovim >= 0.9.0`
- [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
- [Parser requirements][hygen-template-requirements] of
  [`tree-sitter-hygen-template`][hygen-template]
- Icon provider (optional, but recommended):
  - [`nvim-web-devicons`](https://github.com/nvim-tree/nvim-web-devicons)

## Install

### [`lazy.nvim`](https://github.com/folke/lazy.nvim)

```lua
{
  {
    -- tree-sitter stuff
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "Hdoc1509/hygen.nvim" },
    config = function()
      -- NOTE: call this before calling `nvim-treesitter.configs.setup()`
      require("hygen.tree-sitter").setup()

      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", -- optional
          "embedded_template", -- required
          "javascript", -- optional
          "hygen_template", -- required
        },
      })
    end,
  },
  {
    -- nvim-web-devicons stuff
    "nvim-tree/nvim-web-devicons",
    dependencies = { "Hdoc1509/hygen.nvim" },
    config = function()
      require("nvim-web-devicons").setup({})
      require("hygen.web-devicons").setup()
    end,
  }
}
```

### [`packer.nvim`](https://github.com/wbthomason/packer.nvim)

```lua
-- tree-sitter stuff
use {
  "nvim-treesitter/nvim-treesitter",
  requires = { "Hdoc1509/hygen.nvim" },
  config = function()
    -- NOTE: call this before calling `nvim-treesitter.configs.setup()`
    require("hygen.tree-sitter").setup()

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash", -- optional
        "embedded_template", -- required
        "javascript", -- optional
        "hygen_template", -- required
      },
    })
  end,
}

-- nvim-web-devicons stuff
use {
  "nvim-tree/nvim-web-devicons",
  requires = { "Hdoc1509/hygen.nvim" },
  config = function()
    require("nvim-web-devicons").setup({})
    require("hygen.web-devicons").setup()
  end,
}
```

## `inject-hygen-ejs!` directive

Allows to inject `ejs` in [dynamic-injection](#dynamic-injection), i.e., given
`after/queries/bash/injections.scm`:

```query
; extends
; don't forget to include `extends` modeline!

(command
  (string
    (string_content) @injection.content
    (#lua-match? @injection.content "<%%=")
    (#inject-hygen-ejs!)))
```

The example query will inject `ejs` to `bash` strings that contain `<%=`. This
injection will only take effect in `hygen` files that has `bash` parser injected.

## Hygen-ed colored icons

> [!NOTE]
> This utillity requires `nvim-web-devicons` plugin.

`hygen.web-devicons` module exports a `get_icon(filename)` utility. It fallbacks
to `get_icon_color()` utility of `nvim-web-devicons` if `filename` does not match
naming convention.

```lua
local hygen_devicons = require("hygen.web-devicons")

-- returns `icon` for `README.md` file and `hygen` color
local icon, icon_color = hygen_devicons.get_icon("README.md.hygen")

-- now returns `icon` for `md` files
local icon, icon_color = hygen_devicons.get_icon("custom.md.hygen")
```

See screenshots of [Dynamic injection](#dynamic-injection) section for visual
examples.

## Integrations

### [`render-markdown.nvim`](https://github.com/MeanderingProgrammer/render-markdown.nvim)

> [!IMPORTANT]
> Be sure to set `hygen.nvim` as a dependency and to load `render-markdown.nvim`
> for `hygen` filetype.

<details>
  <summary>Configuration example</summary>

The following snippet will allow to attach only to `hygen` files that has `md`
or `mdx` as subextension.

```lua
local hygen_utils = require('hygen.utils')
local allowed_hygen_subext = { 'md', 'mdx' }

require("render-markdown").setup({
  ignore = function(bufnr)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local extension = vim.fn.fnamemodify(filename, ":e")

    if extension == "hygen" then
      return not vim.tbl_contains(
        allowed_hygen_subext,
        hygen_utils.get_hygen_subext(filename)
      )
    else
      return false
    end
  end,
})
```

</details>

### [`tabby.nvim`](https://github.com/nanozuki/tabby.nvim)

> [!IMPORTANT]
> Be sure to set `hygen.nvim` and `nvim-web-devicons` as a dependencies

<details>
  <summary>Configuration example</summary>

```lua
local hygen_devicons = require('hygen.web-devicons')

require("tabby").setup({
  line = function(line)
    return {
      line.tabs().foreach(function(tab)
        local filename = tab.current_win().buf_name()
        local icon, icon_color = hygen_devicons.get_icon(filename)

        -- NOTE: use `icon` and `icon_color` to fit your needs
        return { --[[ ... ]] }
      end),
    }
  end,
})
```

</details>

### [`incline.nvim`](https://github.com/b0o/incline.nvim)

> [!IMPORTANT]
> Be sure to set `hygen.nvim` and `nvim-web-devicons` as a dependencies

<details>
  <summary>Configuration example</summary>

```lua
local hygen_devicons = require('hygen.web-devicons')

require("incline").setup({
  render = function(props)
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
    local icon, icon_color = hygen_devicons.get_icon(filename)

    if filename == '' then
      filename = '[No Name]'
    end

    -- NOTE: use `icon` and `icon_color` to fit your needs
    return { --[[ ... ]] }
  end,
})
```

</details>

### [`mini.files`](https://github.com/echasnovski/mini.files)

> [!IMPORTANT]
> Be sure to set `hygen.nvim` and `nvim-web-devicons` as a dependencies

<details>
  <summary>Configuration example</summary>

```lua
local hygen_devicons = require('hygen.web-devicons')

require("mini.files").setup({
  content = {
    prefix = function(fs_entry)
      local name = fs_entry.name
      local extension = vim.fn.fnamemodify(name, ':e')

      if extension == 'hygen' then
        local icon = hygen_devicons.get_icon(name)
        return icon .. ' ', 'DevIconHygen'
      else
        return MiniFiles.default_prefix(fs_entry)
      end
    end,
  },
})
```

</details>

## Dynamic injection

Dynamic injection is applied following the [file naming convention of
`tree-sitter-hygen-template`][hygen-template-filename]

### `vite.config.ts.hygen`

![vite.config.ts.hygen](https://github.com/user-attachments/assets/d76b78d7-6dcf-4533-ad1e-ad4485ddae66)

> Normal icon

---

![vite.config.ts.hygen with hygen-ed colored icon](https://github.com/user-attachments/assets/0b35474f-31ae-44fb-b112-e9c792d44bd4)

> Hygen-ed colored icon

### `Layout.astro.hygen`

![Layout.astro.hygen](https://github.com/user-attachments/assets/8b226ddb-9776-4e31-8e60-ccd7c6777f17)

> Normal icon

---

![Layout.astro.hygen with hygen-ed colored icon](https://github.com/user-attachments/assets/4bee8cc5-74ed-4246-abfb-9da4b5abdc05)

> Hygen-ed colored icon

### `package.json.hygen`

![package.json.hygen](https://github.com/user-attachments/assets/b86ada76-45fa-426f-8fdf-e72793cf9f95)

> Normal icon

---

![package.json.hygen with hygen-ed colored icon](https://github.com/user-attachments/assets/cbbbaafe-4a16-4b64-bbae-639dbcdb6535)

> Hygen-ed colored icon

## Updates

This plugin will follow changes of [`tree-sitter-hygen-template`][hygen-template]:

- [`queries`][hygen-template-queries] updates
- [`grammar`][hygen-template-grammar] updates

## Thanks

Thanks to [@ngynkvn](https://github.com/ngynkvn) for
[this idea](https://github.com/nvim-treesitter/nvim-treesitter/discussions/1917#discussioncomment-10714144)

[hygen-template]: https://github.com/hdoc1509/tree-sitter-hygen-template
[hygen-template-grammar]: https://github.com/hdoc1509/tree-sitter-hygen-template/tree/master/grammar.js
[hygen-template-queries]: https://github.com/hdoc1509/tree-sitter-hygen-template/tree/master/queries
[hygen-template-filename]: https://github.com/Hdoc1509/tree-sitter-hygen-template#file-naming-convention
[hygen-template-requirements]: https://github.com/Hdoc1509/tree-sitter-hygen-template?tab=readme-ov-file#parser-requirements
