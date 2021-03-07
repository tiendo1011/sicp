(load "metacircular-evaluator-amb-evaluation.scm")
(driver-loop)

(define (require p) (if (not p) (amb)))
(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))
(define count 0)
(let ((x (an-element-of '(a b c)))
      (y (an-element-of '(a b c))))
     (permanent-set! count (+ count 1))
     (require (not (equal? x y)))
     (list x y count))

; What values would have been displayed if we had used
; set! here rather than permanent-set!
; the flow:
; first compare 'a 'a fails, which revert the change and set count to 0
; Then compare a and b, which succeeded & increase count to 1
; The values would be:
; (a b 1)
; (a c 1) (since try-again has same effect as the call to fail)
