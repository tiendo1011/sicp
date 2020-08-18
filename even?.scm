(define (remainder a b)
  (if (< a b)
      a
      (remainder (- a b) b)))

(define (even? n)
  (= (remainder n 2) 0))

(even? 1)
