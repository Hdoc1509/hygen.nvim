(frontmatter
  (metadata
    ((key) @property
      (#any-of? @property
        "to" "from" "force" "unless_exists" "inject" "after" "skip_if" "sh" "before" "prepend"
        "append" "at_line"))))

(frontmatter
  (metadata
    (value
      (string_value) @string)))

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
  (#set! priority 130))

(frontmatter
  (metadata
    (value
      [
        (true)
        (false)
      ] @boolean)))

(frontmatter
  (metadata
    (value
      (number) @number)))
