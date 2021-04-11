; I. factorial machine

(controller
  (assign continue (label fact-done))
  fact-loop
    (test (op =) (reg n) (const 1))
    (branch (label base-case))
    (save continue)
    (save n)
    (assign n (op -) (reg n) (const 1))
    (assign continue (label after-fact))
    (goto (label fact-loop))
  after-fact
    (restore n)
    (restore continue)
    (assign val (op *) (reg n) (reg val))
    (goto (reg continue))
  base-case
    (assign val (const 1))
    (goto (reg continue))
  fact-done)

; let's try with n = 2
(assign continue 'fact-done)
fact-loop
  (test (op =) 2 (const 1))
  (save continue 'fact-done) ; stacks: (continue 'fact-done)
  (save n 2)  ; stacks: (continue 'fact-done) (n 2)
  (assign n 1)
  (assign continue 'after-fact)
  (goto (label fact-loop))
; =>
fact-loop
  (test (op =) 1 (const 1))
  (branch (label base-case))
; =>
base-case
  (assign val 1)
  (goto (reg continue)) ; currently is 'after-fact
; =>
after-fact
  (restore n) ; currently is 2, stacks: (continue 'fact-done) (n)
  (restore continue) ; currently is 'fact-done, stacks: (continue) (n)
  (assign val (op *) 2 1) ; = 2
  (goto (reg continue)) ; currently is 'fact-done; stacks: (continue) (n)

; let's try with n = 3
(assign continue 'fact-done)
fact-loop
  (test (op =) 3 (const 1))
  (save continue 'fact-done) ; stacks: (continue 'fact-done)
  (save n 3)  ; stacks: (continue 'fact-done) (n 3)
  (assign n 2)
  (assign continue 'after-fact)
  (goto (label fact-loop))
; =>
fact-loop
  (test (op =) 2 (const 1))
  (save continue 'after-fact) ; stacks: (continue 'fact-done 'after-fact)
  (save n 2)  ; stacks: (continue 'fact-done 'after-fact) (n 3 2)
  (assign n 1)
  (assign continue 'after-fact)
  (goto (label fact-loop))
; =>
fact-loop
  (test (op =) 1 (const 1))
  (branch (label base-case))
; =>
base-case
  (assign val 1)
  (goto (reg continue)) ; currently is 'after-fact
; =>
after-fact
  (restore n) ; currently is 2, stacks: (continue 'fact-done 'after-fact) (n 3)
  (restore continue) ; currently is 'after-fact, stacks: (continue 'fact-done) (n 3)
  (assign val (op *) 2 1) ; = 2
  (goto (reg continue)) ; currently is 'after-fact; stacks: (continue 'fact-done) (n 3)

; =>
after-fact
  (restore n) ; currently is 3, stacks: (continue 'fact-done)
  (restore continue) ; currently is 'fact-done, stacks: (continue) (n)
  (assign val (op *) 3 2) ; = 6
  (goto (reg continue)) ; currently is 'fact-done; stacks: (continue) (n)

; II. fibonacci machine
(controller
  (assign continue (label fib-done))
  fib-loop
    (test (op <) (reg n) (const 2))
    (branch (label immediate-answer))
    (save continue)
    (assign continue (label afterfib-n-1))
    (save n)
    (assign n (op -) (reg n) (const 1))
    (goto (label fib-loop))
  afterfib-n-1
    (restore n)
    (assign n (op -) (reg n) (const 2))
    (assign continue (label afterfib-n-2))
    (save val)
    (goto (label fib-loop))
  afterfib-n-2
    (assign n (reg val))
    (restore val)
    (restore continue)
    (assign val
            (op +) (reg val) (reg n))
    (goto (reg continue))
  immediate-answer
    (assign val (reg n))
    (goto (reg continue))
  fib-done)

; let's try with n = 2
(controller
  (assign continue 'fib-done)
  fib-loop
    (test (op <) 2 (const 2))
    (save continue) ; stacks: (continue 'fib-done)
    (assign continue 'afterfib-n-1)
    (save n) ; stacks: (continue 'fib-done) (n 2)
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
  (restore n) ; currently is 2, stacks: (continue 'fib-done) (n)
  (assign n 0)
  (assign continue 'afterfib-n-2)
  (save val) ; stacks: (continue 'fib-done) (n) (val 1)
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
  (assign n (reg val)) ; currently is 0
  (restore val) ; currently is 1, stacks: (continue 'fib-done) (n) (val)
  (restore continue); currently is 'fib-done, stacks: (continue) (n) (val)
  (assign val (op +) 1 0) ; = 1
  (goto 'fib-done)

; let's try with n = 3
(controller
  (assign continue 'fib-done)
  fib-loop
    (test (op <) 3 (const 2))
    (save continue) ; stacks: (continue 'fib-done)
    (assign continue 'afterfib-n-1)
    (save n) ; stacks: (continue 'fib-done) (n 3)
    (assign n 2)
    (goto 'fib-loop)
; =>
fib-loop
  (test (op <) 2 (const 2))
  (save continue) ; stacks: (continue 'fib-done 'afterfib-n-1)
  (assign continue 'afterfib-n-1)
  (save n) ; stacks: (continue 'fib-done afterfib-n-1) (n 3 2)
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
  (restore n); currently is 2, stacks: (continue 'fib-done afterfib-n-1) (n 3)
  (assign n 0)
  (assign continue 'afterfib-n-2)
  (save val) ; stacks: (continue 'fib-done afterfib-n-1) (n 3) (val 1)
  (goto 'fib-loop)
; =>
fib-loop
  (test (op <) 0 (const 2))
  (branch 'immediate-answer)
; =>
immediate-answer
  (assign val 0)
  (goto 'afterfib-n-2)
; =>
afterfib-n-2
  (assign n 0)
  (restore val) ; currently is 1; stacks: (continue 'fib-done 'afterfib-n-1) (n 3) (val)
  (restore continue); currently is 'afterfib-n-1, stacks: (continue 'fib-done) (n 3) (val)
  (assign val (+ 1 0)); = 1
  (goto 'afterfib-n-1)
; =>
afterfib-n-1
  (restore n); currently is 3, stacks: (continue 'fib-done) (n) (val)
  (assign n 1)
  (assign continue 'afterfib-n-2)
  (save val); stacks: (continue 'fib-done) (n) (val 1)
  (goto 'fib-loop)
; =>
fib-loop
  (test (op <) 1 (const 2))
  (branch 'immediate-answer)
; =>
immediate-answer
  (assign val 1)
  (goto (reg continue)); currently is 'afterfib-n-2
; =>
afterfib-n-2
  (assign n 1)
  (restore val) ; currently is 1, stacks: (continue 'fib-done) (n) (val)
  (restore continue) ; currently is 'fib-done, stacks: (continue) (n) (val)
  (assign val (+ 1 1)); = 2
  (goto (reg continue)); currently is 'fib-done
