(load "dx.scm")
(load "hop-repeated.scm")

(define (smooth f)
  (lambda (x) (/ (+ (f (- x dx)) (f x) (f (+ x dx))) 3)))

((smooth square) 2)
((smooth (smooth square)) 2)
((smooth (smooth (smooth square))) 2)

(((repeated smooth 1) square) 2)
(((repeated smooth 2) square) 2)
(((repeated smooth 3) square) 2)
