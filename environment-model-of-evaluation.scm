; 1. Syntactic sugar equivalent
(define (square x) (* x x))
; equals to
(define square (lambda (x) (* x x)))

(let ((var exp))
  body)
; equals to
((lambda (var) body) exp)

; What should I see from this?
(lambda (x) (* x x))
; => proc object (param: x, body: (* x x))
