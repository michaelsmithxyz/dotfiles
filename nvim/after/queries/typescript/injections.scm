; extends

; gql(`...`)  -> treat contents as GraphQL
; (call_expression
;   function: (identifier) @_name
;   (#eq? @_name "gql")
;   arguments: (arguments (template_string) @injection.content)
;   (#offset! @injection.content 0 1 0 -1)
;   (#set! injection.include-children)
;   (#set! injection.language "graphql"))
;
; /* GraphQL */ `...`  -> treat contents as GraphQL
((comment) @_comment
  .
  (template_string) @injection.content
  (#match? @_comment "/\\*\\s*GraphQL\\s*\\*/")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "graphql"))
