(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance))
  (define (try guess count)
    (let ((next (f guess)))
         (display next)
         (newline)
         (display "count: ")
         (display count)
         (newline)
         (if (close-enough? guess next)
             next
             (try next (+ count 1)))))
  (try first-guess 0))

(define (no-average-damping x) (/ (log 1000) (log x)))
(define (with-average-damping x) (* 0.5 (+ (/ (log 1000) (log x)) x)))

(fixed-point no-average-damping 2) ; 33
(fixed-point with-average-damping 2) ; 8
