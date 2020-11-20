(define (p . args)
  (for-each (lambda (arg) (display arg)) args)
  (newline))
