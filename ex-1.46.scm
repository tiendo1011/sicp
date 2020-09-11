(load "iterative-improve.scm")

; sqrt
(define (abs x) (if (>= x 0) x (- 0 x)))

(define (average x y)
  (/ (+ x y) 2))

(define (improve x)
  (lambda (guess) (average guess (/ x guess))))

(define (good-enough? guess next-guess)
  (< (abs (- guess next-guess)) 0.00001))

(define (sqrt x)
  ((iterative-improve good-enough? (improve x)) 1.0))

; Fixed-point
(define (fixed-point f first-guess)
  ((iterative-improve good-enough? f) 1.0))

(sqrt 100)
(fixed-point cos 1.0)
