; (rule (append-to-form () ?y ?y))
; (rule (append-to-form (?u . ?v) ?y (?u . ?z))
;       (append-to-form ?v ?y ?z))

; (rule (?x next-to ?y in (?x ?y . ?u)))
; (rule (?x next-to ?y in (?v . ?z))
;       (?x next-to ?y in ?z))

(load "metacircular-evaluator-query-evaluator.scm")
(query-driver-loop)

(assert! (rule (last-pair (?u) (?u))))
(assert! (rule (last-pair (?u . ?v) ?z)
               (last-pair ?v ?z)))

(last-pair (3) ?x)
(last-pair (1 2 3) ?x)
(last-pair (2 ?x) (3))

; It works correctly for the 3 above input, but this one
; sends it into a loop, why?
; To know why, I need to know how it solves the input
; which I don't know at the moment
(last-pair ?x (3))
