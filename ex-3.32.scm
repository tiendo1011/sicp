(define (and-gate a1 a2 output)
  (define (and-action-procedure)
    (let ((new-value
            (logical-and (get-signal a1) (get-signal a2))))
         (after-delay
           and-gate-delay
           (lambda () (set-signal! output new-value))))) ; (1)
  (add-action! a1 and-action-procedure) ; (2)
  (add-action! a2 and-action-procedure) ; (3)
  'ok)

; When and-gate is called,
; it calls (2), which executes and-action-procedure & adds (1) to the-agenda queue
; then it calls (3), which executes and-action-procedure & adds another (1) to the-agenda queue

; set-up:
; a1: 0, a2: 1, and-gate is called, which adds two (1) proc to the agenda
; When a1 changed to 1, and-action-procedure is called, and add another (1) to the agenda
; the new-value when the proc is created is 1 (because a1 is 1, a2 is 1)
; When a2 changed to 0, and-action-procedure is called, and add another (1) to the agenda
; the new-value when the proc is created is 0 (because a1 is 1, a2 is 0)
; in FIFO order, the final calls is when the new-value is set to 0, which is correct

; What if the order is LIFO (Last in, first out)
; The final calls is when the new-value is 1, which is not correct
