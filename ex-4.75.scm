; The unique special form in integrated into the query evaluator
; The code here only verify it works
(load "metacircular-evaluator-query-evaluator.scm")
(query-driver-loop)

(assert! (job (Bitdiddle Ben) (computer wizard)))
(assert! (job (Hacker Alyssa P) (computer programmer)))
(assert! (job (Fect Cy D) (computer programmer)))

(and (job ?x ?j) (unique (job ?anyone ?j)))
; However, (unique (job ?x (computer wizard))) will not
; produce the expected result, since unique is a mean
; to filter the frame-stream, and the frame-stream feeds to
; unique in the latter case is empty
