(define (repeated-compose f n)
  (if (= n 1)
      f
      (compose f (repeated-compose f (- n 1)))))

(define (repeated f n)
  (lambda (x) ((repeated-compose f n) x)))

((repeated square 2) 5)
