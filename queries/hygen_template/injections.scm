(frontmatter
  (metadata
    ((key) @key
      (#eq? @key "sh"))
    (value
      ((string_value) @injection.content
        (#set! injection.language "bash")))))

((code) @injection.content
  (#set! injection.language "javascript")
  (#set! injection.combined))
(frontmatter
  (metadata
    ((key) @key
      (#any-of? @key "after" "skip_if" "before"))
    (value
      ((string_value) @injection.content
        (#set! injection.language "regex")))))

; dynamic injection
((content) @injection.content
  (#inject-hygen-tmpl!)
  (#set! injection.combined))
