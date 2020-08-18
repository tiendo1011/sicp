(define (square a) (* a a))

(define (abs x) (if (>= x 0) x (- 0 x)))

(define (average x y)
  (/ (+ x y) 2))

(define (improve guess x)
  (average guess (/ x guess)))

(define (good-enough? guess improved-guess)
  (< (abs (- guess improved-guess)) 0.001))

(define (sqrt-iter guess x)
  (define improved-guess (improve guess x))
  (if (good-enough? guess improved-guess)
      improved-guess
      (sqrt-iter improved-guess x)))

(sqrt-iter 1.0 1000000000000000)
