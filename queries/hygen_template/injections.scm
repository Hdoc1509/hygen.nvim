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

(frontmatter
  (metadata
    (value
      (output_directive
        (code) @injection.content
        (#set! injection.language "javascript")))))

(template
  (frontmatter)? @frontmatter
  (body
    [
      (directive
        (code) @injection.content)
      (output_directive
        (code) @injection.content)
    ]
    (#not-lua-match? @frontmatter "from:")
    (#set! injection.language "javascript")
    (#set! injection.combined)))

; dynamic injection
(template
  (frontmatter)? @frontmatter
  (body
    ((content) @injection.content
      (#not-lua-match? @frontmatter "from:")
      (#inject-hygen-tmpl! @frontmatter)
      (#set! injection.combined))))
