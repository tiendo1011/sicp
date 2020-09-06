(load "cont-frac.scm")

(define (d i)
  (if (= (remainder i 3) 2)
      (* (remainder i 3) 2)
      1))
(+ 2 (cont-frac (lambda (i) 1.0) d 10))
