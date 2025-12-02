<!-- markdownlint-disable MD024 MD033 -->

# hygen.nvim

Plugin that adds support for [Hygen](https://www.hygen.io/) templates in Neovim.

![Hygen template with Markdown parser injected](https://github.com/user-attachments/assets/2746bd28-d01b-404c-80a4-4494dacae330)

## Features

- Syntax highlighting for `Hygen` templates thanks to
  [`tree-sitter-hygen-template`][hygen-template]. Compatible with
  [`v0.5.0`][tree-sitter-hygen-template-version]
- [Dynamic parser injection](#dynamic-injection)
- [New directive](#inject-hygen-ejs-directive) to customize injections
- Utility to get [hygen-colored icons](#hygen-colored-icons)
- [LSP configuration](#lsp-configuration)
- [Integrations](#integrations) with other plugins

## Requirements

- `Neovim >= 0.9.0`
- [`nvim-treesitter`][nvim-treesitter]
- [`bash` parser][bash] (optional): for `metadata.value` when `metadata.key` is
  `sh`
- [`javascript` parser][javascript] (optional): for `code` nodes
- [`regex` parser][regex] (optional): for `metadata.value` when `metadata.key`
  is `after`, `before` or `skip_if`
- [`embedded_template` parser][embedded-template] (optional): needed for
  [new directive](#inject-hygen-ejs-directive)
- Icon provider (optional, but recommended):
  - [`nvim-web-devicons`][nvim-web-devicons]

## Install

### [`lazy.nvim`](https://github.com/folke/lazy.nvim)

#### `nvim-treesitter`

```lua
{
  "nvim-treesitter/nvim-treesitter",
  dependencies = { "Hdoc1509/hygen.nvim" },
  config = function()
    -- NOTE: call this before calling `nvim-treesitter.configs.setup()`
    require("hygen.tree-sitter").setup()

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash", -- optional
        "embedded_template", -- optional
        "hygen_template", -- required
        "javascript", -- optional
        "regex", -- optional
      },
    })
  end,
}
```

#### `nvim-web-devicons`

```lua
{
  "nvim-tree/nvim-web-devicons",
  dependencies = { "Hdoc1509/hygen.nvim" },
  config = function()
    require("nvim-web-devicons").setup({})
    require("hygen.web-devicons").setup()
  end,
}

```

### [`packer.nvim`](https://github.com/wbthomason/packer.nvim)

#### `nvim-treesitter`

```lua
use({
  "nvim-treesitter/nvim-treesitter",
  requires = { "Hdoc1509/hygen.nvim" },
  config = function()
    -- NOTE: call this before calling `nvim-treesitter.configs.setup()`
    require("hygen.tree-sitter").setup()

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash", -- optional
        "embedded_template", -- optional
        "hygen_template", -- required
        "javascript", -- optional
        "regex", -- optional
      },
    })
  end,
})
```

#### `nvim-web-devicons`

```lua
use({
  "nvim-tree/nvim-web-devicons",
  requires = { "Hdoc1509/hygen.nvim" },
  config = function()
    require("nvim-web-devicons").setup({})
    require("hygen.web-devicons").setup()
  end,
})
```

## `inject-hygen-ejs!` directive

> [!IMPORTANT]
> This directive requires `embedded_template` parser.

This directive allows to inject `ejs` in [dynamic-injection](#dynamic-injection),
i.e., having `after/queries/bash/injections.scm` in user's config directory:

```query
; extends
; don't forget to include `extends` modeline!

(command
  (string
    (string_content) @injection.content
    (#lua-match? @injection.content "<%%=")
    (#inject-hygen-ejs! "")))
```

The example query will inject `ejs` to `bash` strings that contain `<%=` and are
also string arguments of a command. This injection will only take effect in
`hygen` files that has `bash` parser injected.

## Hygen-colored icons

> [!NOTE]
> This utillity requires `nvim-web-devicons` plugin.

The [`hygen.web-devicons`](./lua/hygen/web-devicons.lua) module exports the
`get_icon(filename)` utility. It fallbacks to `nvim-web-devicons` if `filename`
does not match naming convention.

```lua
local hygen_devicons = require("hygen.web-devicons")

-- `icon` for `README.md` file, hygen `color` and `hl` group of hygen `color`
local icon, color, hl = hygen_devicons.get_icon("README.md.hygen")

-- now returns `icon` for `md` files
local icon, color, hl = hygen_devicons.get_icon("custom.md.hygen")
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

The following snippet will allow to attach to `hygen` files that has `md` or
`mdx` as subextension.

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
    local filename = vim.fs.basename(vim.api.nvim_buf_get_name(props.buf))
    local icon, icon_color = hygen_devicons.get_icon(filename)

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
      if fs_entry.fs_type == 'directory' then
        return ' ', 'MiniFilesDirectory'
      end

      local icon, _, hl = hygen_devicons.get_icon(fs_entry.name)
      return icon .. ' ', hl
    end,
  },
})
```

</details>

## LSP configuration

The `hygen.ts-query-ls` module exports an LSP configuration for `ts_query_ls`
server to register the custom directives used by this plugin.

### [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + neovim < 0.11

> [!IMPORTANT]
> Be sure to set `hygen.nvim` as a dependency

```lua
local lspconfig = require('lspconfig')
local hygen_ts_query_ls = require('hygen.ts-query-ls')

lspconfig.ts_query_ls.setup(vim.tbl_deep_extend('force', {
  -- your settings
}, hygen_ts_query_ls))
```

### vim.lsp.config

<!-- TODO: need to check if it works correctlty -->

> [!IMPORTANT]
> Be sure to load `hygen.nvim` during startup

```lua
local hygen_ts_query_ls = require('hygen.ts-query-ls')

vim.lsp.enable('ts_query_ls')
vim.lsp.config('ts_query_ls', vim.tbl_deep_extend('force', {
  -- your settings
}, hygen_ts_query_ls))
```

### `<rtp>/lsp/` folder

<!-- TODO: need to check if it works correctlty -->

> [!IMPORTANT]
> Be sure to load `hygen.nvim` during startup

```lua
local hygen_ts_query_ls = require('hygen.ts-query-ls')

return vim.tbl_deep_extend('force', {
  -- your settings
}, hygen_ts_query_ls)
```

## Dynamic injection

Dynamic injection is applied following the [file naming convention of
`tree-sitter-hygen-template`][hygen-template-filename]

### `vite.config.ts.hygen`

![vite.config.ts.hygen](https://github.com/user-attachments/assets/24b3985c-72a2-4696-ae7f-07c563a6ec93)

> Normal icon

---

![vite.config.ts.hygen with hygen-colored icon](https://github.com/user-attachments/assets/290e7e9b-0d5c-4b16-9624-b195d6923118)

> Hygen-colored icon

### `Layout.astro.hygen`

![Layout.astro.hygen](https://github.com/user-attachments/assets/b4bcf1e0-f2b7-4e5a-91d0-918c8610206a)

> Normal icon

---

![Layout.astro.hygen with hygen-colored icon](https://github.com/user-attachments/assets/4079d0fe-f12b-4f77-b12d-fc01fd9ec60b)

> Hygen-colored icon

### `package.json.hygen`

![package.json.hygen](https://github.com/user-attachments/assets/004e9b0b-2a99-407d-a604-7820f84c643d)

> Normal icon

---

![package.json.hygen with hygen-colored icon](https://github.com/user-attachments/assets/de26b3c7-5da3-4dda-8e4c-856cad53a49e)

> Hygen-colored icon

### `mini.files`

![mini.files](https://github.com/user-attachments/assets/058b3ffa-4426-437c-86bd-68e816427c04)

> Normal icon

![mini.files with hygen-colored icon](https://github.com/user-attachments/assets/093aa55b-3850-4960-86f7-527b30ec1a84)

> Hygen-colored icon

### `metadata-from-key.md.hygen`

![Hygen template with ignored body](https://github.com/user-attachments/assets/019a7cb6-ce79-47c5-b4d7-e52d7c04eb91)

> [Ignored template's body][ignored-template-body] highlighted as comment
> because of presence of `from` metadata key

## Updates

This plugin will follow changes of `tree-sitter-hygen-template`:

- [`queries`][hygen-template-queries] updates
- [`grammar`][hygen-template-grammar] updates

## Thanks

Thanks to [@ngynkvn](https://github.com/ngynkvn) for
[this idea](https://github.com/nvim-treesitter/nvim-treesitter/discussions/1917#discussioncomment-10714144)

[hygen-template]: https://github.com/hdoc1509/tree-sitter-hygen-template
[hygen-template-grammar]: https://github.com/hdoc1509/tree-sitter-hygen-template/tree/master/grammar.js
[hygen-template-queries]: https://github.com/hdoc1509/tree-sitter-hygen-template/tree/master/queries
[hygen-template-filename]: https://github.com/Hdoc1509/tree-sitter-hygen-template#file-naming-convention
[tree-sitter-hygen-template-version]: https://github.com/Hdoc1509/tree-sitter-hygen-template/blob/master/CHANGELOG.md#050
[embedded-template]: https://github.com/tree-sitter/tree-sitter-embedded-template
[bash]: https://github.com/tree-sitter/tree-sitter-bash
[javascript]: https://github.com/tree-sitter/tree-sitter-javascript
[regex]: https://github.com/tree-sitter/tree-sitter-regex
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[nvim-web-devicons]: https://github.com/nvim-tree/nvim-web-devicons
[ignored-template-body]: https://github.com/jondot/hygen/blob/master/hygen.io/docs/templates.md#from--shared-templates
