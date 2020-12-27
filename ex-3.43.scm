; a1: 30, a2: 20, a3: 10
; If it runs sequencially, it means it's the permutation of a set {a1, a2, a3}

; If the exchange doesn't run sequencially:
; process 1 check the difference between a1 & a2: 10
; process 2 check the difference between a2 & a3: 10
; process 1 swap a1 & a2: a1 (30-10=20), a2 (20+10=30)
; process 2 swap a2 & a3: a2 (30-10=20), a1 (10+10=20)
; So we ended up with 20, 20, 20

; The sum is preserve because no matter the order of calculating difference, deposit, withdrawal,
; if we subtract an amount, we always add the same amount back

; If we did not serialize the transactions on individual accounts, the deposit/withdrawal might
; happens simultaniously, & gets the same balance, then set the balance to difference value
