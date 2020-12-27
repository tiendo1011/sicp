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
; this triggers stream-filter on seq (cons 1 (delay (stream-map ...)))
; which already been visited by the call to y, so some of the result will be skipped
; The last sum is 6
; The last touch in seq is (cons 3 ...)
; So when it touches 4, the new sum will be 10
; And the touch to 4 will be memorized

(stream-ref y 7)
; (cons 6 ...) 7 (1 + 2 + 3)
; (cons 10 ...) 6 (1 + 2 + 3 + 4)
; (cons 28 ...) 5 (1 + 2 + 3 + 4 + 5 + 6 + 7)
; (cons 36 ...) 4 (1 + 2 + 3 + 4 + 5 + 6 + 7 + 8)
; (cons 66 ...) 3 (1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10 + 11)
; (cons 78 ...) 2 (1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10 + 11 + 12)
; (cons 120 ...) 1 (1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10 + 11 + 12 + 13 + 14 + 15)
; (cons 136 ...) 0 (1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10 + 11 + 12 + 13 + 14 + 15 + 16)
; sum now is 136

(display-stream z)
; (cons 10 (delay stream-map (stream-cdr 4 ..)))
; (cons 15 (delay stream-map (stream-cdr 5 ...))
; (cons 45 (delay stream-map (stream-cdr 9 ...)))
; (cons 55 (delay stream-map (stream-cdr 10 ...)))
; (cons 105 (delay stream-map (stream-cdr 14 ...)))
; after this, stream-filter will stops at the end of the stream
; sum will run until the end, so sum will be 206


; the printed response:
; stream-ref is 136
; display-stream is 'done

; Would these responses differ if we had implemented (delay ⟨ exp ⟩ )
; simply as (lambda () ⟨ exp ⟩ ) without using the optimization provided by memo-proc ? Explain.
; How to I know this
; These reponses means the printed response of each one
; For memo-proc version, if it already run, it'll not run again, and it keep the
; last sum intact
; For normal version (without memo-proc), it re-runs
; let's see what happens if we re-run this accum with the same value twice:
(define sum 0)
(define (accum x) (set! sum (+ x sum)) sum)

(accum 1) ; 1
(accum 1) ; 2
; => It does changes the sum
; The value of sum changes, but what about the printed response?
; It does change, since the sum is the car of stream
