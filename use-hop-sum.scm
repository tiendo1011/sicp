(load "hop-sum.scm")
(load "hop-sum-iterative.scm")
(load "cube.scm")

(define (inc n) (+ n 1))
(define (sum-cubes a b)
  (sum cube a inc b))

(define (sum-cubes-iterative a b)
  (sum-iterative cube a inc b))

(define (identity x) x)

(define (sum-integers a b)
  (sum identity a inc b))
(define (sum-integers-iterative a b)
  (sum-iterative identity a inc b))

; The formula is in page 79
(define (integral f a b dx)
  (define (add-dx x)
    (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

(sum-cubes 1 10)
(sum-cubes-iterative 1 10)
(sum-integers 1 10)
(sum-integers-iterative 1 10)
