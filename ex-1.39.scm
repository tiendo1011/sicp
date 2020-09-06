(define (cont-frac n d k x)
  (define (run i)
    (if (= i k)
        (/ (n k x) (d k))
        (/ (n i x) (- (d i) (run (+ i 1))))))
  (run 1))

(define (n i x)
  (if (= i 1)
      x
      (* x x)))
(define (d i)
  (- (* 2 i) 1.0))
(define (tan-cf x k)
  (cont-frac n d k x))

(tan-cf 10 20)
