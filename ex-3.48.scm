(define (make-account-and-serializer balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serializer)))
       (define (dispatch m)
         (cond ((eq? m 'withdraw) withdraw)
               ((eq? m 'deposit) deposit)
               ((eq? m 'balance) balance)
               ((eq? m 'serializer) balance-serializer)
               (else (error "Unknown request: MAKE-ACCOUNT" m))))
       dispatch))

(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer)))
       ((serializer1 (serializer2 exchange))
        account1
        account2)))

; Imagine that Peter attempts to exchange a1 with a2 while Paul concurrently
; attempts to exchange a2 with a1.
; Suppose that Peter’s process reaches the point where it has entered a
; serialized procedure protecting a1 and,
; just after that, Paul’s process enters a serialized procedure protecting a2.
; Now Peter cannot proceed (to enter a serialized procedure protecting a2)
; until Paul exits the serialized procedure protecting a2. Similarly, Paul
; cannot proceed until Peter exits the serialized procedure protecting a1

; 2 processes:
; (serialized-exchange a1 a2)
; (serialized-exchange a2 a1)
; What is serializer? It's a procedure object, that receives a procedure
; as argument and return a serialized procedure
; So serialized-exchange account1 account 2 is basically:
; (serializer2 exchange) => return a serialized exchange which is protected by serializer2
; Which is:
; mutex2 'acquire
; exchange
; mutex2 'release

; (serializer1 (serializer2 exchange))
; Which is
; mutex1 'acquire
; mutex2 'acquire
; exchange
; mutex2 'release
; mutex1 'release

; Apply to the case with 2 processes:
; (serialized-exchange a1 a2)
; =>
; mutex1 'acquire (1)
; mutex2 'acquire
; exchange
; mutex2 'release
; mutex1 'release

; (serialized-exchange a2 a1)
; mutex2 'acquire (2)
; mutex1 'acquire
; exchange
; mutex1 'release
; mutex2 'release

; Peter just acquire (1)
; Paul just acquire (2)
; Both wait for the other to release

; To answer the exercise question
; Q: Explain in detail why the deadlock-avoidance method described above,
; (i.e., the accounts are numbered,
; and each process attempts to acquire the smaller-numbered
; account first) avoids deadlock in the exchange problem.

; A: with that, the order of execution has changed
; (serialized-exchange a1 a2)
; =>
; mutex1 'acquire (1)
; mutex2 'acquire
; exchange
; mutex2 'release
; mutex1 'release

; (serialized-exchange a2 a1)
; mutex1 'acquire (2)
; mutex2 'acquire
; exchange
; mutex2 'release
; mutex1 'release

; after Peter has acquired (1), any attempt to enter serialized-exchange will have to wait, since
; to enter it, it has to acquire mutex1

(load "mutex.scm")
(define count 0)
(define mutex (make-mutex))

; Modified version
(define (make-account-and-serializer balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serializer))
        (account-number 0))
        (begin
          (mutex 'acquire)
          (set! count (+ count 1))
          (set! account-number count)
          (mutex 'release))
       (define (dispatch m)
         (cond ((eq? m 'withdraw) withdraw)
               ((eq? m 'deposit) deposit)
               ((eq? m 'balance) balance)
               ((eq? m 'serializer) balance-serializer)
               ((eq? m 'account-number) account-number)
               (else (error "Unknown request: MAKE-ACCOUNT" m))))
       dispatch))

(define account1 (make-account-and-serializer 100))
(define account2 (make-account-and-serializer 100))
(define account3 (make-account-and-serializer 100))
(account1 'account-number)
(account2 'account-number)
(account3 'account-number)

; (define (serialized-exchange account1 account2)
;   (let ((serializer1 (account1 'serializer))
;         (serializer2 (account2 'serializer)))
;        (if (< (account1 'account-number) (account2 'account-number))
;            ((serializer1 (serializer2 exchange)) account1 account2)
;            ((serializer2 (serializer1 exchange)) account1 account2))))
