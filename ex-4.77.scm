(define (negate operands frame-stream)
  (stream-flatmap
    (lambda (frame)
      (if (frame-has-unbound-variable? frame)
          (append-promise frame operands)
          (if (stream-null?
                (qeval (negated-query operands)
                       (singleton-stream frame)))
              (singleton-stream frame)
              the-empty-stream))
    frame-stream)))
(put 'not 'qeval negate)

; 1. When to trigger frame evaluation?
; First of all, we only append promise if the variable inside the operands is unbound
; inside frame
; Second of all, to perform filtering ASAP, we need to place it where we know that the frame is extend
; it means inside extend procedure
; the plan is that when we extend, if the variable is equal to the variable we need, we evaluate the promise
; what does it mean to evaluate the promise?
; for negate procedure, it means frame -> the empty-stream

; 2. frame now has both promise & bindings, how other methods works with that?
; it still works since binding-in-frame is located using assoc, which finds the variable
; independent of the order of items in frame
; which seems like a good abstraction barrier to me
