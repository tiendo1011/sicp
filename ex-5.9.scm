; The check is integrated into make-operation-exp
; with content like this:
(if (label-exp? e)
    (error "can't work with label: MAKE-OPERATION-EXP")
    (make-primitive-exp e machine labels))
