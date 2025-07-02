# hygen.nvim

Neovim plugin that integrates [`tree-sitter-hygen-template`][hygen-template]
to provide syntax highlighting for [Hygen](https://www.hygen.io/) templates.

![Hygen template with Markdown parser injected](https://github.com/user-attachments/assets/4d386909-d889-4e4c-a138-9adc5d70920c)

> Hygen template with Markdown parser injected

## Features

- Syntax highlighting for [Hygen](https://www.hygen.io/) templates.
- Dynamic parser injection based on file extension (see [dynamic injection](#dynamic-injection))
- New [directive](#inject-hygen-ejs-directive) to customize injections
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
> This feature requires `nvim-web-devicons` plugin.

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

See screenshots of [Dynamic injection](#dynamic-injection) section for examples.

## Filetype

This plugin will set `filetype` to `hygen` to all files that match the name
pattern `<file-name>.(ext).hygen`.

> [!NOTE]
> See [file name pattern convention][hygen-template-filename] of
> `tree-sitter-hygen-template` for more information.

## Dynamic injection

Dynamic injection is applied to template body, based on file extension.

Target `parser` to inject will be extracted from `file.(ext).hygen`.

> [!NOTE]
> See [dynamic injection][hygen-template-dynamic-injection] of
> `tree-sitter-hygen-template` for more information.

<!-- TODO: add screenshots with and without using `hygen.web-devicons.get_icon()`
utility -->

### `file.ts.hygen`

![Hygen template with typescript parser injected](https://github.com/user-attachments/assets/0c0e7fd9-c1ee-4fea-9515-0a012eae1316)

### `file.astro.hygen`

![Hygen template with astro parser injected](https://github.com/user-attachments/assets/fbe4fa0f-526d-44bf-afb1-3604e011b3ec)

### `file.json.hygen`

![Hygen template with json parser injected](https://github.com/user-attachments/assets/da3ef597-b92f-4a43-8540-429ec28c208a)

## Updates

This plugin will follow changes of [`tree-sitter-hygen-template`][hygen-template]:

- [`queries`][hygen-template-queries] updates
- [`grammar`][hygen-template-grammar] updates

## Thanks

Thanks to [@reegnz](https://github.com/reegnz) for
[this idea](https://github.com/nvim-treesitter/nvim-treesitter/discussions/1917#discussioncomment-2091384)

[hygen-template]: https://github.com/hdoc1509/tree-sitter-hygen-template
[hygen-template-grammar]: https://github.com/hdoc1509/tree-sitter-hygen-template/tree/master/grammar.js
[hygen-template-queries]: https://github.com/hdoc1509/tree-sitter-hygen-template/tree/master/queries
[hygen-template-dynamic-injection]: https://github.com/Hdoc1509/tree-sitter-hygen-template?tab=readme-ov-file#dynamic-injection
[hygen-template-filename]: https://github.com/Hdoc1509/tree-sitter-hygen-template?tab=readme-ov-file#file-name-pattern-convention
[hygen-template-requirements]: https://github.com/Hdoc1509/tree-sitter-hygen-template?tab=readme-ov-file#parser-requirements
