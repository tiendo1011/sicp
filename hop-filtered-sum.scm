(load "hop-filtered-accumulate.scm")

(define (filtered-sum term a next b predicate)
  (filtered-accumulate + 0 term a next b predicate))
