(define (cons x y) (lambda (m) (m x y)))
(define (car z) (z (lambda (p q) p)))
(define (cdr z) (z (lambda (p q) q)))

; To print it in some reasonable way
; We need a way to identify cons with normal lambda procedure
; Not sure how to do it, though
