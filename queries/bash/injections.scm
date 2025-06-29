; extends

(command
  (string
    (string_content) @injection.content
    (#lua-match? @injection.content "^<%%=")
    (#inject-hygen-bash-ejs!)))

(command
  (concatenation
    (string
      (string_content) @injection.content
      (#lua-match? @injection.content "^<%%=")
      (#inject-hygen-bash-ejs!))))
