; Show how to implement unless as a derived expression (like cond or let)

; It's actually pretty easy
; Just parse the (unless condition usual-value exceptional-value)
; and turn them into (if condition exceptional-value usual-value)

; give an example of a situation where it might be useful to have unless
; available as a procedure, rather than as a special form
;
; If we want to pass unless to higher order procedure as that procedure argument
; we can't do that with the syntax version
