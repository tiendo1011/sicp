; To see why, we need to see how the code is evaluated in both cases
; Let's try it
; If we define map, then the flow is:
; evaluate (define (map proc items) body)
; (definition? exp) => true
; calls eval-definition
; calls define-variable! map (make-lambda params body)

; when calls:
; (map car (list (list 1 2) (list 1 2)))
; application? => true
; m-apply map-proc (car-proc (list (list 1 2) (list 1 2)))
; it's handled as compound-procedure, where it maps the params to
; the arguments (which is already evaluated by the calls to list-of-values)
; then it triggers the body

; If we use the primative map
; then it'll be handled as primitive-procedure
; which calls apply-primitive-procedure
; which apply map-proc to args
; args is (car (list (list 1 2) (list 1 2)))
; but args is not evaluated yet, so for example,
; car in the call to map is just a symbol, not a proc object
