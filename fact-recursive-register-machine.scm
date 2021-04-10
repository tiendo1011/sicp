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
; first cycle
(controller
  (assign continue (label fact-done))
  fact-loop
    (test (op =) 2 (const 1))
    (save continue 'fact-done')
    (save n 2)
    (assign n 1)
    (assign continue (label after-fact))
    (goto (label fact-loop))
  fact-done)

; second cycle
(controller
  fact-loop
    (test (op =) 1 (const 1))
    (branch (label base-case))
  base-case
    (assign val (const 1))
    (goto (reg continue)) ; currently is after-fact
  fact-done)

; =>
  after-fact
    (restore n) ; 2
    (restore continue) ; fact-done
    (assign val (op *) 2 1)
    (goto (reg continue)) ; currently is fact-done
; => val is 2

; let's try with n = 3
; first cycle
(controller
  (assign continue (label fact-done))
  fact-loop
    (test (op =) 3 (const 1))
    (save continue 'fact-done')
    (save n 3)
    (assign n 2)
    (assign continue (label after-fact))
    (goto (label fact-loop))
  fact-done)

; second cycle
(controller
  (assign continue (label fact-done))
  fact-loop
    (test (op =) 2 (const 1))
    (save continue 'after-fact)
    (save n 2)
    (assign n 1)
    (assign continue (label after-fact))
    (goto (label fact-loop))
  fact-done)

; third cycle
(controller
  fact-loop
    (test (op =) 1 (const 1))
    (branch (label base-case))
  base-case
    (assign val (const 1))
    (goto (reg continue)) ; currently is after-fact
  fact-done)

; =>
  after-fact
    (restore n) ; 2
    (restore continue) ; after-fact
    (assign val (op *) 2 1)
    (goto (reg continue)) ; currently is after-fact

; =>
  after-fact
    (restore n) ; 3
    (restore continue) ; fact-done
    (assign val (op *) 3 2)
    (goto (reg continue)) ; currently is fact-done
; => val is 6
