# hygen.nvim

## 0.4.0

### Minor Changes

- Add `maintainers` of parser ([#4](https://github.com/Hdoc1509/hygen.nvim/pull/4))

- Allow customization of `install_info` for parser ([#4](https://github.com/Hdoc1509/hygen.nvim/pull/4))

- Export settings for `ts_query_ls` ([#4](https://github.com/Hdoc1509/hygen.nvim/pull/4))

- Complete exported settings for `ts_query_ls` ([#4](https://github.com/Hdoc1509/hygen.nvim/pull/4))

- Use specific version of `tree-sitter-hygen-template` ([#4](https://github.com/Hdoc1509/hygen.nvim/pull/4))

### Patch Changes

- Apply injection of `embedded_template` based on filetype too ([#4](https://github.com/Hdoc1509/hygen.nvim/pull/4))

- Ensure correct highlight of ignored body ([#4](https://github.com/Hdoc1509/hygen.nvim/pull/4))

- Handle changes of `nvim-treesitter` in `main` branch ([#4](https://github.com/Hdoc1509/hygen.nvim/pull/4))

- Set correct specification for `inject-hygen-tmpl` directive ([#4](https://github.com/Hdoc1509/hygen.nvim/pull/4))

- Add `tier` of parser ([#4](https://github.com/Hdoc1509/hygen.nvim/pull/4))

- Handle changes of treesitter directive handler from neovim 0.10 ([#4](https://github.com/Hdoc1509/hygen.nvim/pull/4))

## 0.3.1

### Patch Changes

- Set correct config example for `mini.files` integration ([`682430c`](https://github.com/Hdoc1509/hygen.nvim/commit/682430c2ea25be1c10ec314520a7da32a6731334))

## 0.3.0

### Minor Changes

- Add filetype icon for `nvim-web-devicons` ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

- Add `inject-hygen-ejs!` directive ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

- Complete list of valid `metadata.key` nodes to be highlighted ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

- Add highlight capture for `true` and `false` nodes ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

- Inject `regex` to `metadata.value` to some `metadata.key` nodes ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

- Add highlight capture for `number` nodes ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

- Skip injection to `code` nodes if there is `from` key in frontmatter ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

- Skip dynamic injection if there is `from` key in frontmatter ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

- Improve `injections` query of `embedded_template` ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

- Implement new file naming convention ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

- Highlight `body` as comment if there is `from` key in frontmatter ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

- Add more highlights in frontmatter ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

### Patch Changes

- Skip dynamic injection if file does not match naming convention ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

- Ignore files with `ejs`, `erb` and `hygen` subextions ([#3](https://github.com/Hdoc1509/hygen.nvim/pull/3))

## 0.2.0

### Minor Changes

- Use main color of `hygen` website as icon color ([`e152f55`](https://github.com/Hdoc1509/hygen.nvim/commit/e152f555e0ecacb5900218d46430f29ce575604e))

## 0.1.0

### Initial release

- [9d6591f](https://github.com/Hdoc1509/hygen.nvim/commit/9d6591f4f7955e28d10a64c8fd2f78294d267585): Initial release
