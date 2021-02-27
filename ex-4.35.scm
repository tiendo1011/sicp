(define (an-integer-between a b)
  (require (> b a))
  (amb a (an-integer-between (+ a 1) b)))
