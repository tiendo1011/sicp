(load "square.scm")
(load "smallest-divisor-improved.scm")

(define (prime? n)
  (= n (smallest-divisor n)))

(prime? 6)
(prime? 561)
