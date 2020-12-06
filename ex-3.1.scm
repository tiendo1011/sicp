(define (make-accumulator initial-sum)
  (lambda (value)
    (begin (set! initial-sum (+ initial-sum value))
           initial-sum)))

(define A (make-accumulator 5))
(A 10)
(A 10)
