; How can a rule gives me some clue about what the result might be?
; (?x next-to ?y in (1 (2 3) 4))

; Not entirely sure, but I think the result might be:
; (1 next-to (2 3) in (1 (2 3) 4))
; ((2 3) next-to 4 in (1 (2 3) 4))
; (2 next-to 3 in (1 (2 3) 4))

; Let's verify it
(load "metacircular-evaluator-query-evaluator.scm")

(query-driver-loop)
(assert! (rule (?x next-to ?y in (?x ?y . ?u))))
(assert! (rule (?x next-to ?y in (?v . ?z))
      (?x next-to ?y in ?z)))
(?x next-to ?y in (1 (2 3) 4))

; The result:
; ((2 3) next-to 4 in (1 (2 3) 4))
; (1 next-to (2 3) in (1 (2 3) 4))
; => It can't scan the nested list inside

; (?x next-to 1 in (2 1 3 1))
; I think the result will be
; (2 next-to 1 in (2 1 3 1))
; (3 next-to 1 in (2 1 3 1))
