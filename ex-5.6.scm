; It's mark as * down here
  afterfib-n-1
    (restore n)
    (restore continue) ; *
    (assign n (op -) (reg n) (const 2))
    (save continue)    ; *
    (assign continue (label afterfib-n-2))
    (save val)
    (goto (label fib-loop))

; The funny thing is that, I saw this when trying to simulate the machine
; and thought it's the authors mistake, turns out it's not
; That's a good one, haha
