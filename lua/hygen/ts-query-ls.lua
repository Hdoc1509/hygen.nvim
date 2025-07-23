return {
  settings = {
    valid_predicates = {
      ["has-hygen-from-key"] = {
        parameters = {
          { type = "capture", arity = "required" },
        },
        description = 'Check if the given frontmatter has the "from" key',
      },
    },
  },
}
