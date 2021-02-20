; I'm thinking: The program that calculates fibonacci number

; Give the responses both when the evaluator memoizes and when it does not.
(define count 0)
(define (id x) (set! count (+ count 1)) x)
(define (square x) (* x x))
;;; L-Eval input:
(square (id 10))
;;; L-Eval value:
⟨ response ⟩
;;; L-Eval input:
count
;;; L-Eval value:
⟨ response ⟩

; The only way you can know is evaluate it
; Let's evaluating (square (id 10))
; This will evaluate the square body with x is set to the delayed object (id 10)
; The body is (* x x)
; This will force the x
; if x is memorized
; then (id 10) will only be execute one
; which set count to 1, and (square (id 10)) will return 100

; if x is not memorized, then (id 10) will be execute twice
; which set count to 2, and (square (id 10)) will still returns 100
