; factorial machine

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
