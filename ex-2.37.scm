(load "matrix-operation.scm")

(define v (list 1 2 3))
(define w (list 4 5 6))
(define m (list v w))

(dot-product v v)
(dot-product v w)

(matrix-*-vector m v)
(transpose m)
(matrix-*-matrix m m)
