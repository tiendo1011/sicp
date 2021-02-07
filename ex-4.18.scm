(load "stream.scm")
; How do I know if it works?
; Try to run it
(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream
      initial-value
      (let ((integrand (force delayed-integrand)))
           (add-streams (scale-stream integrand dt) int))))
  int)

; (define (solve f y0 dt)
;   (define y (integral (delay (force dy)) y0 dt))
;   (define dy (delay (stream-map f y)))
;   y)

; (define
;   solve
;   (lambda (f y0 dt)
;     (let ((y '*unassigned*) (dy '*unassigned*))
;       (let ((a (integral (delay (force dy)) y0 dt))
;             (b (delay (stream-map f y))))
;         (set! y a)
;         (set! dy b)
;         y))))

; (define
;   solve
;   (lambda (f y0 dt)
;           (let ((y '*unassigned*) (dy '*unassigned*))
;                (set! y (integral (delay (force dy)) y0 dt))
;                (set! dy (delay (stream-map f y)))
;                y)))

(stream-ref (solve (lambda (y) y) 1 0.001) 1000)

; I see that both versions work, but the solution from the internet says
; differently: https://wizardbook.wordpress.com/2011/01/03/exercise-4-18/
; The explanation does make sense, though
