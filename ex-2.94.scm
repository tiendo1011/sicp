(load "generic-arithmetic-operations.scm")

(define p1 (make-polynomial
'x '((4 1) (3 -1) (2 -2) (1 2))))
(define p2 (make-polynomial 'x '((3 1) (1 -1))))

(gcd p1 p2)
