(load "square.scm")

(define (product term a next b)
  (if (> a b)
    1
    (* (term a) (product term (next a) next b))))

(define (factorial n)
  (define (factorial-term x) x)
  (define (factorial-next x) (+ x 1))
  (product factorial-term 1 factorial-next n))

(define (calculate-pi n)
  (define (term x) (/ (* x (+ x 2)) (square (+ x 1))))
  (define (next x) (+ x 2))
  (* 4.0 (product term 2 next n)))

(factorial 6)
(calculate-pi 1000)
