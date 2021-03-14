; the cons-stream will delay the evaluation of the cdr until it's needed
; so (set! THE-ASSERTIONS (cons-stream assertion THE-ASSERTIONS))
; the variable THE-ASSERTIONS in the later one when evaluated will be the just set
; THE-ASSERTIONS, not the one before set operation takes place
