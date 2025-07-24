return {
  settings = {
    valid_predicates = {
      ["has-hygen-from-key"] = {
        parameters = {
          { type = "capture", arity = "required" },
        },
        description = 'Check if the given frontmatter has the `from` key',
      },
    },
    valid_directives = {
      ["inject-embedded_template"] = {
        parameters = {
          { type = "string", arity = "optional" },
        },
        description = "Directive to handle `ejs` and `erb` injections",
      },
      ["inject-hygen-ejs"] = {
        parameters = {
          { type = "string", arity = "optional" },
        },
        description = "Injects `ejs` in dynamic injections. Only have effect in `hygen` files.",
      },
      ["inject-hygen-tmpl"] = {
        parameters = {
          { type = "capture", arity = "required" },
        },
        description = "Directive to enable dynamic injections for `hygen` files.",
      },
    },
  },
}
