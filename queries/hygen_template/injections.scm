(frontmatter
  (metadata
    ((key) @key
      (#eq? @key "sh"))
    (value
      ((string_value) @injection.content
        (#set! injection.language "bash")))))

(frontmatter
  (metadata
    ((key) @key
      (#any-of? @key "after" "skip_if" "before"))
    (value
      ((string_value) @injection.content
        (#set! injection.language "regex")))))

(template
  (frontmatter)? @frontmatter
  (body
    [
      (directive
        (code) @injection.content)
      (output_directive
        (code) @injection.content)
    ]
    (#not-has-hygen-from-key? @frontmatter)
    (#set! injection.language "javascript")
    (#set! injection.combined)))

; dynamic injection
(template
  (frontmatter)? @frontmatter
  (body
    ((content) @injection.content
      (#not-has-hygen-from-key? @frontmatter)
      (#inject-hygen-tmpl! @frontmatter)
      (#set! injection.combined))))
