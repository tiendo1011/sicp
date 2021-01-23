(define (integral integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (add-streams (scale-stream integrand dt)
                              int)))
  int)

(define (RC R C dt)
  (lambda (i vo)
    (add-streams (integral (scale-stream i (/ 1 C)) vo dt)
                 (scale-stream i R))))
