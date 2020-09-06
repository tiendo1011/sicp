(load "hop-accumulate.scm")

(define (sum term a next b)
  (accumulate + 0 term a next b))
