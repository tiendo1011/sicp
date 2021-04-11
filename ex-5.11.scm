; Current state of the machine
(controller
  (assign continue (label fib-done))
  fib-loop
    (test (op <) (reg n) (const 2))
    (branch (label immediate-answer))
    (save continue)                            ; 1
    (assign continue (label afterfib-n-1))
    (save n)                                   ; 2
    (assign n (op -) (reg n) (const 1))
    (goto (label fib-loop))
  afterfib-n-1
    (restore n)                                 ; 3
    (assign n (op -) (reg n) (const 2))
    (assign continue (label afterfib-n-2))
    (save val)                                  ; 4
    (goto (label fib-loop))
  afterfib-n-2
    (assign n (reg val))
    (restore val)                               ; 5
    (restore continue)                          ; 6
    (assign val
            (op +) (reg val) (reg n))
    (goto (reg continue))
  immediate-answer
    (assign val (reg n))
    (goto (reg continue))
  fib-done)

; a. (restore y) puts into y the last value saved on the
; stack, regardless of what register that value came from.

; Let's simulate the machine with one stack and see
; If we can eliminate one instruction, then it should work for the simplest case
; which triggers all the execution path
; which is n = 2
; let's try it
(controller
  (assign continue 'fib-done)
  fib-loop
    (test (op <) 2 (const 2))
    (save continue) ; stacks: ('fib-done)
    (assign continue 'afterfib-n-1)
    (save n)        ; stacks: ('fib-done 2)
    (assign n 1)
    (goto 'fib-loop)
; =>
fib-loop
  (test (op <) 1 (const 2))
  (branch 'immediate-answer)
; =>
immediate-answer
  (assign val 1)
  (goto (reg continue)) ; currently is 'afterfib-n-1
; =>
afterfib-n-1
  (restore n) ; currently is 2, stacks: ('fib-done) (maybe here?)
  (assign n 0)
  (assign continue 'afterfib-n-2)
  (save val) ; currently is 1, ('fib-done 1)
  (goto 'fib-loop)
; =>
fib-loop
  (test (op <) 0 (const 2))
  (branch 'immediate-answer)
; =>
immediate-answer
  (assign val 0)
  (goto (reg continue)) ; currently is 'afterfib-n-2
; =>
afterfib-n-2
  (assign n 0)
  (restore val) ; currently is 1, stacks: ('fib-done)
  (restore continue) ; currently is 'fib-done, stacks: ()
  (assign val (+ 0 1)) ; = 1
  (goto (reg continue)); currently is 'fib-done

; b.
(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
       (lambda ()
               (push stack ((stack-inst-reg-name inst) (get-contents reg)))
               (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst)))
        (top (pop stack)))
       (lambda ()
         (if (equal? (car top) reg)
             (begin
               (set-contents! reg top)
               (advance-pc pc))
             (begin (push stack top)
                    (error "last push value is not from reg: MAKE-RESTORE" reg))))))

; c. A nested stack will do
