(template
  (frontmatter
    (metadata
      ((key) @property
        (#any-of? @property
          "to"
          "from"
          "force"
          "unless_exists"
          "inject"
          "after"
          "skip_if"
          "sh")))))

(template
  (frontmatter
    (metadata
      (value
        (string_value) @string))))

(frontmatter
  "---" @punctuation.delimiter)

(frontmatter
  (metadata
    ":" @punctuation.delimiter))

(comment_directive) @comment

([
  "<%#"
  "<%"
  "<%="
  "<%_"
  "<%-"
  "%>"
  "-%>"
  "_%>"
] @keyword
  (#highlight-increase-ejs-priority!))
