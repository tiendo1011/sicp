(define count 0)
(define (id x) (set! count (+ count 1)) x)

(define w (id (id 10)))
;;; L-Eval input:
count
;;; L-Eval value:
⟨response⟩
;;; L-Eval input:
w
;;; L-Eval value:
⟨ response ⟩
;;; L-Eval input:
count
;;; L-Eval value:
⟨ response ⟩

; The execution flow:
; evaluate (define w (id (id 10)))
; set w to the result of evaluating (id (id 10))
; which calls m-apply to id procedure with arguments as (id 10)
; this evaluate the id proc body, with (id 10) as argument object (but a delayed one)
; the evaluation of id proc body set count to 1 and return x, which is the delayed object above
; so w is set to the delayed object
; so count is 1, w is the delayed object

; When we call w, it forces the delayed object and trigger (id 10) evaluation
; which set count to 2 and return x as 10
; so w is set to 10

; the call to count returns the newest count, which is 2
