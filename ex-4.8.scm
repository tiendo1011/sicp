; It's integrated to metacircular-evaluator.scm
; I didn't think it can work like that
; but you can define a proc (in this scenario: fib-iter)
; which calls itself in its body
; without defining it first
; Although it looks pretty twisted
; it makes sense since the body of the proc
; is not executed when it's defined, but when it's called
