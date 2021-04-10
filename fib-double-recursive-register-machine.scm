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
    (restore continue)
    (assign n (op -) (reg n) (const 2))
    (save continue)
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

; let's try with n = 1
(controller
  (assign continue 'fib-done)
  fib-loop
    (test (op <) 1 (const 2))
    (branch 'immediate-answer)
  immediate-answer
    (assign val 1)
    (goto 'fib-done))

; let's try with n = 2
(controller
  (assign continue 'fib-done)
  fib-loop
    (test (op <) 2 (const 2))
    (save continue 'fib-done)
    (assign continue 'afterfib-n-1)
    (save n 2)
    (assign n 1)
    (goto 'fib-loop))

; =>
  fib-loop
    (test (op <) 1 (const 2))
    (branch 'immediate-answer)
  immediate-answer
    (assign val 1)
    (goto (reg continue)) ; currently is 'afterfib-n-1
; =>
  afterfib-n-1
    (restore n) ; 2
    (restore continue) ; fib-done
    (assign n 0)
    (save continue 'fib-done)
    (assign continue 'afterfib-n-2)
    (save val) ; currently is 1
    (goto 'fib-loop)

; =>
  fib-loop
    (test (op <) 0 (const 2))
    (brach 'immediate-answer)
  immediate-answer
    (assign val 0)
    (goto (reg continue)) ; currently is 'afterfib-n-2

; =>
  afterfib-n-2
    (assign n 0)
    (restore val) ; currently is 1
    (restore continue) ; currently is 'fib-done
    (assign val (op +) 1 0)
    (goto (reg continue)) ; currently is 'fib-done

; let's try with n = 3
(controller
  (assign continue 'fib-done)
  fib-loop
    (test (op <) 3 (const 2))
    (save continue 'fib-done)
    (assign continue 'afterfib-n-1)
    (save n 3)
    (assign n 2)
    (goto 'fib-loop))

; =>
  fib-loop
    (test (op <) 2 (const 2))
    (save continue 'afterfib-n-1)
    (assign continue 'afterfib-n-1)
    (save n 2)
    (assign n 1)
    (goto 'fib-loop)
; =>
  fib-loop
    (test (op <) 1 (const 2))
    (branch (label 'immediate-answer))
  immediate-answer
    (assign val 1)
    (goto (req continue)) ; currently is 'afterfib-n-1
; =>
  afterfib-n-1
    (restore n) ;currently is 2
    (assign n 0)
    (assign continue 'afterfib-n-2)
    (save val 1)
    (goto 'fib-loop)
; =>
  fib-loop
    (test (op <) 0 (const 2))
    (branch (label 'immediate-answer))
  immediate-answer
    (assign val 0)
    (goto (reg continue)) ; currently is 'afterfib-n-2
; =>
  afterfib-n-2
    (assign n 0) ;
    (restore val) ; currently is 1
    (restore continue) ; currently is 'afterfib-n-1
    (assign val 1)
    (goto (reg continue)) ; currently is 'afterfib-n-1
; =>
  afterfib-n-1
    (restore n) ; currently is 3
    (assign n 1)
    (assign continue 'afterfib-n-2)
    (save val 1)
    (goto (label fib-loop))
; =>
  fib-loop
    (test (op <) 1 (const 2))
    (branch (label 'immediate-answer))
  immediate-answer
    (assign val 1)
    (goto (reg continue)) ; currently is 'afterfib-n-2
; =>
  afterfib-n-2
    (assign n 1)
    (restore val) ; currently is 1
    (restore continue) ; currently is 'fib-done
    (assign val 2)
    (goto (reg continue)) ; currently is 'fib-done
