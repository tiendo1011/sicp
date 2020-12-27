; For example, there are 2 calls to this procedure concurrently:
(define (transfer from-account to-account amount)
  ((from-account 'withdraw) amount)
  ((to-account 'deposit) amount))

; Because withdraw procedure is serialized inside from-account, 2 calls will run sequencially
; So it still works
; Same for deposit
; So Louis is wrong

; The essential difference is that exchange needs to read balance, which is not serialized
