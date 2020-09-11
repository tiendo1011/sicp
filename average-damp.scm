(load "square.scm")
(load "average.scm")

(define (average-damp f)
  (lambda (x) (average x (f x))))

((average-damp square) 10)
