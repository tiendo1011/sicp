; (lambda <vars>
;   (define u <e1>)
;   (define v <e2>)
;   <e3>)

; expected transformed output:
; (lambda <vars>
;   (let ((u '*unassigned*)
;         (v '*unassigned*))
;     (set! u <e1>)
;     (set! v <e2>)
;     <e3>))
; which is the same as:
; (lambda <vars>
;   ((lambda (u v)
;     ((set! u <e1>)
;     (set! v <e2>)
;     <e3>)) '*unassigned* '*unassigned*))

; The extra frame is for the second call to lambda, which set u, v to '*unassigned*
; The different in environment structure can never make a difference in the behavior of
; a correct program because the binding of u, v is set right at the beginning of the body
; and <e3> expression is evaluated in a frame which has the enclosing env as where
; the u, v is set to its correct value

; To reduce the extra frame, we need to reduce the extra lambda?
