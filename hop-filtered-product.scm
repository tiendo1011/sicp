(load "hop-filtered-accumulate.scm")

(define (filtered-product term a next b predicate)
  (filtered-accumulate * 1 term a next b predicate))
