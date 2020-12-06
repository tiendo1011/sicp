(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else
            (error "Unknown request: MAKE-ACCOUNT"
                   m))))
  dispatch)

; bind make-account to a procedure object in global env
; procedure object:
; param: balance
; body:
(define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else
            (error "Unknown request: MAKE-ACCOUNT"
                   m))))
  dispatch
; enclosing env: global

(define acc (make-account 50))
; 1.1 (make-account 50)
; execute in E1
; binds balance to 50
; execute the body
(define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
; binds withdraw to a procedure object
; procedure object:
; param: amount
; body:
(if (>= balance amount)
    (begin (set! balance (- balance amount))
           balance)
    "Insufficient funds")
; enclosing env: E1

(define (deposit amount)
  (set! balance (+ balance amount))
  balance)
; binds deposit to a procedure object
; procedure object:
; param: amount
; body:
(set! balance (+ balance amount))
  balance
; enclosing env: E1

(define (dispatch m)
  (cond ((eq? m 'withdraw) withdraw)
        ((eq? m 'deposit) deposit)
        (else
          (error "Unknown request: MAKE-ACCOUNT"
                 m))))
; binds dispatch to a procedure object
; procedure object: (1)
; param: m
; body:
(cond ((eq? m 'withdraw) withdraw)
      ((eq? m 'deposit) deposit)
      (else
        (error "Unknown request: MAKE-ACCOUNT"
               m)))
; enclosing env: E1

dispatch
; then returns dispatch
; which means the calls to (make-account 50) returns a procedure object (1)

; 1.2 (define acc (make-account 50))
; => binds acc to procedure object (1) in global env

; 2. ((acc 'deposit) 40)
; 2.1 evaluate (acc 'deposit) in E2
; binds m to 'deposit
; evaluate the body:
(cond ((eq? m 'withdraw) withdraw)
      ((eq? m 'deposit) deposit)
      (else
        (error "Unknown request: MAKE-ACCOUNT"
               m)))
; => return deposit, it finds deposit variable
; since acc binds to a procedure object with enclosing env is E1, it finds deposit variable in E1 first
; and E1 indeed has one
; it returns deposit procedure object
; 2.2 evaluate (deposit 40)
; evaluate deposit procedure object in E3
; binds amount to 40
; evaluate the body:
(set! balance (+ balance amount))
  balance
; it needs to find balance from enclosing env (which is E1,
; where deposit is defined)
; in E1, balance is 50
; So the result is:
(set! balance (+ 50 40))
balance
; which replace the binding for balance in E1 to 90
; and return the binding, which is 90

; 3 ((acc 'withdraw) 60)
; 3.1 evaluate (acc 'withdraw) in E4
; binds m to 'withdraw
; evaluate the body:
(cond ((eq? m 'withdraw) withdraw)
      ((eq? m 'deposit) deposit)
      (else
        (error "Unknown request: MAKE-ACCOUNT"
               m)))
; return withdraw
; it finds withdraw in E1
; 3.2 evaluate (withdraw 60)
; binds amount to 60
; evaluate the body:
(if (>= balance amount)
    (begin (set! balance (- balance amount))
           balance)
    "Insufficient funds")
; it finds balance, which is in E1 with the value of 90
set! balance (- 90 60)
balance
; binds balance to 30
; return 30

; Q: Where is the local state for acc kept?
; A: The local state for acc kept: balance

; Q: Suppose we define another account
; (define acc2 (make-account 100))
; How are the local states for the two accounts kept distinct?
; A: Those 2 local states are kept in 2 different env

; Q: Which parts of the environment structure are shared between acc and acc2 ?
; A: The code are shared
