(load "square.scm")
(load "smallest-divisor-improved.scm")

(define (prime? n)
  (if (< n 2)
      false
      (= n (smallest-divisor n))))

(prime? 1)
(prime? 6)
(prime? 7)
(prime? 561)
