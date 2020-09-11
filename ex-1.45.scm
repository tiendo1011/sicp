(load "fixed-point.scm")
(load "average-damp.scm")
(load "hop-repeated.scm")

(define (sqrt x)
  (fixed-point (average-damp (lambda (y) (/ x y))) 1.0))

(define (cbrt x)
  (fixed-point (average-damp (lambda (y) (/ x (* y y)))) 1.0))

(define (find-root exponent x)
  (let ((average-damp-count (floor (log exponent 2))))
   (fixed-point ((repeated average-damp average-damp-count) (lambda (y) (/ x (expt y (- exponent 1))))) 1.0)))

(find-root 2 2); y^2 = x ; require 1 average-damp
(find-root 3 2) ; y^3 = x;
(find-root 4 2) ; require 2 average-damp
(find-root 5 2)
(find-root 6 2)
(find-root 8 2) ; require 3 average-damp
(find-root 9 2)
(find-root 10 2)
(find-root 11 2)
(find-root 12 2)
(find-root 13 2)
(find-root 14 2)
(find-root 15 2)
(find-root 16 2) ; require 4 average-damp
(find-root 17 2)
(find-root 100 2)
