(load "print-point.scm")

(define (make-point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))

(define (make-segment p1 p2) (cons p1 p2))
(define (start-segment s) (car s))
(define (end-segment s) (cdr s))

(define (midpoint-segment segment)
  (let ((p1 (start-segment segment))
        (p2 (end-segment segment))
        (x (/ (+ (x-point p1) (x-point p2)) 2))
        (y (/ (+ (y-point p1) (y-point p2)) 2)))
    (make-point x y)))

(define p1 (make-point 1.0 2.0))
(define p2 (make-point 2.0 3.0))
(define s1 (make-segment p1 p2))
(print-point (midpoint-segment s1))
