; The need arises when the operation is a delayed object
; the delayed object is the result of the call to delay-it
; which only execute if we call list-of-delayed-args
; which is executed only if apply is called

; let's try higher order procedure
; (map proc items)
; proc will be a delayed object
; when we evaluate (proc item)
; that's a delayed object and we need to force it to get to the real object
