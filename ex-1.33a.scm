(load "hop-filtered-sum.scm")
(load "hop-filtered-product.scm")
(load "square.scm")
(load "inc.scm")
(load "prime?")
(load "identity.scm")

(define (is-prime-and-less-than i)
  (and (< i 7) (prime? i)))

(filtered-sum square 1 inc 10 prime?)
(filtered-product identity 1 inc 10 is-prime-and-less-than)
