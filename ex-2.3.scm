; ========= NOTE ========
; Although I discover the suitable abstraction barriers
; (Using rect-length & rect-width), I made a mistake when
; allowing building a rectangle with length & width only
; (without caring about the condition that it needs to be
; on the plane, with segment)
; The 2 correct representations:
; 1. 2 points: bottom-left & top-right
; 2. 1 points, length & width

; First presentation: 2 points
(define (make-point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))

(define (make-rect p1 p2) (cons p1 p2))
(define (start-rect r) (car r))
(define (end-rect r) (cdr r))

(define (rect-length r)
  (let ((p1 (start-rect r))
        (p2 (end-rect r)))
   (- (x-point p2) (x-point p1))))

(define (rect-width r)
  (let ((p1 (start-rect r))
        (p2 (end-rect r)))
   (- (y-point p2) (y-point p1))))

; Second presentation: one-point, width & length
(define (make-rect2 base-point len width) (cons (cons len width) base-point))
(define (rect-length2 r) (car (car r)))
(define (rect-width2 r) (cdr (car r)))

; rect-perimeter & rect-area
(define (rect-perimeter r rect-length rect-width)
  (+ (* (rect-length r) 2) (* (rect-width r) 2)))

(define (rect-area r rect-length rect-width)
  (* (rect-length r) (rect-width r)))

; Calculate using first presentaion: 2 point
(define p1 (make-point 1.0 2.0))
(define p2 (make-point 2.0 3.0))
(define r1 (make-rect p1 p2))
(rect-perimeter r1 rect-length rect-width)
(rect-area r1 rect-length rect-width)

; Calculate using second presentaion: one-point, width & length pairs
(define p3 (make-point 1.0 2.0))
(define r2 (make-rect2 p3 1.0 1.0))
(rect-perimeter r2 rect-length2 rect-width2)
(rect-area r2 rect-length2 rect-width2)
