(load "square.scm")
(load "smallest-divisor.scm")

(define (prime? n)
  (= n (smallest-divisor n)))

(prime? 6)
