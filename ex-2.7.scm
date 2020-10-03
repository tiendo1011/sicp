(define (upper-bound y)
  (if (> (car y) (cdr y))
      (car y)
      (cdr y)))

(define (lower-bound y)
  (if (< (car y) (cdr y))
      (car y)
      (cdr y)))
