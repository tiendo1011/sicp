; a. The lazy evaluator only delay the evaluation of the arguments

; b.
; I run it with metacircular-evaluator-lazy-evaluation
; with the original eval-sequence
; (p1 1) returns (1 2)
; (p2 1) returns 1

; With Cy D.Fect version
; (p1 1) returns (1 2)
; (p2 1) returns (1 2)

; Let's see why (p2 1) changes:
(define (p2 x)
  (define (p e)
    e
    x)
  (p (set! x (cons x '(2)))))
; For the original version
; when e is evaluated, it's a delayed object, and m-eval doesn't force evaluating it, so x doesn't change
; For the updated version, e is forced, so x is reset to (1 2)

; c. actual-value can handle both normal & thunk exp

; d. I think Cy's approach is pretty neat, since that's what we normally expect
