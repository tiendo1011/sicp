; Important point to note:
; The enclosing env of the for-each-except procedure object is global, since it's where it is defined.
; When it's called, it structure a new environment and binds the argument to the parameter, which is:
; setter: 'user
; inform-about-value: procedure object
; constraints: '()
; Then it evaluates the body, if the body contains some variable that's not available in the environment,
; it'll look up in global
