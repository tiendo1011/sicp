(define (square a) (* a a))

(define (abs x) (if (>= x 0) x (- 0 x)))

(define (improve guess x)
  (/ (+ (/ x (* guess guess)) (* 2 guess)) 3))

(define (good-enough? guess improved-guess)
  (< (abs (- guess improved-guess)) 0.001))

(define (cbrt-iter guess x)
  (define improved-guess (improve guess x))
  (if (good-enough? guess improved-guess)
      improved-guess
      (cbrt-iter improved-guess x)))

(cbrt-iter 1.0 8)
