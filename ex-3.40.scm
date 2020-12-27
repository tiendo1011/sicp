(define x 10)
(parallel-execute (lambda () (set! x (* x x)))
                  (lambda () (set! x (* x x x))))

; possible values of x:
; 10^6: P1 set x, then P2 set x
; 10^6: P2 set x, then P1 set x
; 1000: P1 and P2 get x, P1 set x then P2 set x
; 100: P1 and P2 get x, P2 set x then P1 set x
; 10^4: P2 set x between 2 times P1 get x
; 10*100*100, 10*10*100: P1 set x between 3 times P2 get x

; if we use serialized procedures, only 2 remains, which produces the same result
