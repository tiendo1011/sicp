(define make-withdraw
  (lambda (initial-amount)
          ((lambda (balance)
               (lambda (amount)
                       (if (>= balance amount)
                           (begin (set! balance (- balance amount))
                                  balance)
                           "Insufficient funds"))) initial-amount)))

; global env:
; make-withdraw bound to a procedure object that is produced by evaluating the lambda expression:
; param: initial-amount
; body:
((lambda (balance)
               (lambda (amount)
                       (if (>= balance amount)
                           (begin (set! balance (- balance amount))
                                  balance)
                           "Insufficient funds"))) initial-amount)
; enclosing env: global

; 1. (define W1 (make-withdraw 100))
; 1.1 (make-withdraw 100)
; evaluate in E1:
; bind initial-amount to 100
; evaluate the body:
((lambda (balance)
               (lambda (amount)
                       (if (>= balance amount)
                           (begin (set! balance (- balance amount))
                                  balance)
                           "Insufficient funds"))) 100)

; evaluating the lambda exp creates a new procedure object:
; param: balance
; body:
(lambda (amount)
        (if (>= balance amount)
            (begin (set! balance (- balance amount))
                   balance)
            "Insufficient funds"))
; enclosing env: E1

; then this procedure object is called with 100, so it's evaluated in E2:
; bind balance to 100
; evaluate the body
(lambda (amount)
        (if (>= 100 amount)
            (begin (set! balance (- 100 amount))
                   100)
            "Insufficient funds"))
; this creates a procedure object (1):
; param: amount
; body:
(if (>= balance amount)
    (begin (set! balance (- balance amount))
           balance)
    "Insufficient funds")
; enclosing env: E2

; 1.2 bind W1 to the returned value of evaluating (make-withdraw 100)
; which is procedure object (1)

; 2. (W1 50)
; evaluate in E3
; bind amount to 50
; evaluate the body:
(if (>= 100 50)
    (begin (set! balance (- 100 50))
           100)
    "Insufficient funds")
; => set balance = 50
; => return 100

; The objects are the same because the code is the same and the enclosing env both has balance is binded to 100
; The env structures here is one more deeper
