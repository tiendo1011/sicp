(load "hop-accumulate.scm")

(define (product term a next b)
  (accumulate * 1 term a next b))
