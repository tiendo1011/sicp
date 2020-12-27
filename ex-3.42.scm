; Original version
(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
       (define (dispatch m)
         (cond ((eq? m 'withdraw) (protected withdraw))
               ((eq? m 'deposit) (protected deposit))
               ((eq? m 'balance) balance)
               (else (error "Unknown request: MAKE-ACCOUNT"
                            m))))
       dispatch))

; Ben's version
(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
       (let ((protected-withdraw (protected withdraw))
             (protected-deposit (protected deposit)))
            (define (dispatch m)
              (cond ((eq? m 'withdraw) protected-withdraw)
                    ((eq? m 'deposit) protected-deposit)
                    ((eq? m 'balance) balance)
                    (else
                      (error "Unknown request: MAKE-ACCOUNT"
                             m))))
            dispatch)))

; is there any difference in what concurrency is allowed by these two versions of make-account?
(define acc (make-account 100))
((acc 'withdraw) 10)
((acc 'withdraw) 10)
; For the original version, the 2 withdraws are treated as 2 separate serialized procedures
; Which has to wait for each other
; For the modified version, the 2 withdraws are treated as the same serialized procedures
; not sure if they can interleave with each other, if not, then it's safe to do so
