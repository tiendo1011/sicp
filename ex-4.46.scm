; amb evaluator evaluates them from left to right.
; Explain why our parsing program wouldn’t work if the operands were evaluated in some other order.
; Let's check a place where amb is used
(amb verb-phrase
         (maybe-extend
           (list 'verb-phrase
                 verb-phrase
                 (parse-prepositional-phrase))))

; If amb is evaluated from right to left, then (maybe-extend verb-phrase) will evaluate
; (maybe-extend (list 'verb-phrase) ...) first
; and in turn evaluate (maybe-extend (list 'verb-phrase)...)
; which leads to an infinite loop
