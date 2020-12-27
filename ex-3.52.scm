(define sum 0)
; sum is 0
(define (accum x) (set! sum (+ x sum)) sum)
; sum is 0
(define seq
  (stream-map accum
              (stream-enumerate-interval 1 20)))
#1: (stream-enumerate-interval 1 20)
(cons 1 (delay (stream-map accum (stream-cdr #1))) ; (1)
; sum is 1
(define y (stream-filter even? seq))
; seq starts with 1
; 1 is not even
; so it forces to run the next round, which forces
; the delay part of (1) to run
; which triggers (accum 2)
; sum becomes 3
#2: (stream-enumerate-interval 2 20)
; stream-map is now (cons 3 (delay (stream-map accum (stream-cdr #2))))
; which is still not even
; it runs again
; now sum will becomes 6
#3: (stream-enumerate-interval 3 20)
; stream-map is now (cons 6 (delay (stream-map accum (stream-cdr #3))))
; and it stops:
; (cons 6 (delay (stream-filter ...)))

(define z
  (stream-filter (lambda (x) (= (remainder x 5) 0)) seq))
;
(stream-ref y 7)
(display-stream z)
