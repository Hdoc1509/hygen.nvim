# hygen.nvim

Neovim plugin that integrates [`tree-sitter-hygen-template`][hygen-template]
to provide syntax highlighting for [Hygen](https://www.hygen.io/) templates.

![Hygen template with Markdown parser injected](https://github.com/user-attachments/assets/4d386909-d889-4e4c-a138-9adc5d70920c)

> Hygen template with Markdown parser injected

## Features

- Syntax highlighting for [Hygen](https://www.hygen.io/) templates.
- Dynamic parser injection based on file extension (see [dynamic injection](#dynamic-injection))

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
    dependencies = {
      -- latest commit
      "Hdoc1509/hygen.nvim",
      -- specific release
      -- { "Hdoc1509/hygen.nvim", tag = "vX.X.X"  },
      -- { "Hdoc1509/hygen.nvim", version = "X.X.X"  },
    },
    config = function()
      -- NOTE: call this before calling `nvim-treesitter.configs.setup()`
      require("hygen.tree-sitter").setup()

      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          -- other parsers
          "bash", -- optional
          "embedded_template", -- required
          "javascript", -- optional
          "hygen_template", -- required
        },
        -- other options
      })
    end,
  },
  {
    -- nvim-web-devicons stuff
    "nvim-tree/nvim-web-devicons",
    dependencies = {
      -- latest commit
      "Hdoc1509/hygen.nvim",
      -- specific release
      -- { "Hdoc1509/hygen.nvim", tag = "vX.X.X"  },
      -- { "Hdoc1509/hygen.nvim", version = "X.X.X"  },
    },
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
  requires = {
      -- latest commit
      "Hdoc1509/hygen.nvim",
      -- specific release
      -- { "Hdoc1509/hygen.nvim", tag = "vX.X.X"  },
  },
  config = function()
    -- NOTE: call this before calling `nvim-treesitter.configs.setup()`
    require("hygen.tree-sitter").setup()

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        -- other parsers
        "bash", -- optional
        "embedded_template", -- required
        "javascript", -- optional
        "hygen_template", -- required
      },
      -- other options
    })
  end,
}

-- nvim-web-devicons stuff
use {
  "nvim-tree/nvim-web-devicons",
  requires = {
      -- latest commit
      "Hdoc1509/hygen.nvim",
      -- specific release
      -- { "Hdoc1509/hygen.nvim", tag = "vX.X.X"  },
  },
  config = function()
    require("nvim-web-devicons").setup({})
    require("hygen.web-devicons").setup()
  end,
}
```

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

[hygen-template]: https://github.com/hdoc1509/tree-sitter-hygen-template
[hygen-template-grammar]: https://github.com/hdoc1509/tree-sitter-hygen-template/tree/master/grammar.js
[hygen-template-queries]: https://github.com/hdoc1509/tree-sitter-hygen-template/tree/master/queries
[hygen-template-dynamic-injection]: https://github.com/Hdoc1509/tree-sitter-hygen-template?tab=readme-ov-file#dynamic-injection
[hygen-template-filename]: https://github.com/Hdoc1509/tree-sitter-hygen-template?tab=readme-ov-file#file-name-pattern-convention
[hygen-template-requirements]: https://github.com/Hdoc1509/tree-sitter-hygen-template?tab=readme-ov-file#parser-requirements
