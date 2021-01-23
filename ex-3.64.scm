(load "stream-paradigm.scm")

(define (stream-limit s tolerance)
  (let ((s0 (stream-car s))
        (s1 (stream-car (stream-cdr s))))
    (if (< (abs (- s1 s0)) tolerance)
        (display s1)
        (stream-limit (stream-cdr s) tolerance))))

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(sqrt 2 0.001)
