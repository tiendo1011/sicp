; Chase through half-adder
(half-adder input-1 input-2 sum carry)
; =>
(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
       (or-gate a b d)
       (and-gate a b c)
       (inverter c e)
       (and-gate d e s)
       'ok))

; input-1 = a, input-2 = b, sum = s, carry = c
; evaluate the body:
; create d, e
; run or-gate with a b d

(define (or-gate a1 a2 output)
  (define (or-action-procedure)
    (let ((new-value
            (logical-or (get-signal a1) (get-signal a2))))
         (after-delay
           or-gate-delay
           (lambda () (set-signal! output new-value)))))
  (add-action! a1 or-action-procedure)
  (add-action! a2 or-action-procedure)
  'ok)
; a1 = a, a2 = b, output = d
; evaluate the body:
; define or-action-procedure with no param
; call (add-action! a1 or-action-procedure)
; on wire a1, run

(define (accept-action-procedure! proc)
  (set! action-procedures
        (cons proc action-procedures))
  (proc))

; proc = or-action-procedure
; evaluate the body:
; set! action-procedures = new value
; evaluate the proc
; proc is or-action-procedure => the difference is between evaluating that proc, what difference does it make?
; This procedure calls after-delay

(define (after-delay delay action)
  (add-to-agenda! (+ delay (current-time the-agenda))
                  action
                  the-agenda))

; This calls add-to-agenda!, if it's not being run, nothing is added to the agenda
; If nothing is added, nothing is being run by propagate method
