(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer)))
       ((serializer1 (serializer2 exchange))
        account1
        account2)))

; It seems to me that it'll lead to deadlock
; Since the calls to (serializer2 exchange) is not finish, yet the call to (serializer2 deposit) starts
; And they'll be waiting for each other forever
