(load "generic-arithmetic-operations.scm")

(define t1 '((2 1) (0 1)))
(define t2 '((5 1) (0 1)))
(define p1 (make-polynomial 'x t1))
(define p2 (make-polynomial 'x t2))
(define rf (make-rational p2 p1))
(add rf rf)
