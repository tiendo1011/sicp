; register machine
; a. recursive count-leaves:
(define (count-leaves tree)
  (cond ((null? tree) 0)
        ((not (pair? tree)) 1)
        (else (+ (count-leaves (car tree))
                 (count-leaves (cdr tree))))))

; This machine will be similar to fib machine, with too leg
; one for (count-leaves (car tree))
; one for (count-leaves (cdr tree))

; b. recursive count-leaves with explicit counter:
; For each count-iter, it'll produce 2 smaller
; count-iter, one for (cdr tree), one for (car tree)
; pretty similar with the one above, the only different
; is that the one above is independent of each other
; this one has the operation to count (cdr tree) wrap
; around the operation to count (car tree), so it needs
; to wait for the inner one to finish before it can proceed
