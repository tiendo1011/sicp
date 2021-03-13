(load "metacircular-evaluator-query-evaluator.scm")
(query-driver-loop)

(assert! (supervisor (Hacker Alyssa P) (Bitdiddle Ben)))
(assert! (supervisor (Fect Cy D) (Bitdiddle Ben)))
(assert! (supervisor (Tweakit Lem E) (Bitdiddle Ben)))
(assert! (supervisor (Bitdiddle Ben) (Warbucks Oliver)))

(assert! (supervisor (Reasoner Louis) (Hacker Alyssa P)))

(assert! (supervisor (Cratchet Robert) (Scrooge Eben)))
(assert! (supervisor (Scrooge Eben) (Warbucks Oliver)))

(assert! (supervisor (Aull DeWitt) (Warbucks Oliver)))

(assert! (rule (wheel ?person)
               (and (supervisor ?middle-manager ?person)
                    (supervisor ?x ?middle-manager))))

(wheel ?who)

; Why is Oliver Warbucks listed four times?
; Because there're four records where the rule body is satisfied
; (Hacker Alyssa P) (Bitdiddle Ben) (Warbucks Oliver)
; (Fect Cy D) (Bitdiddle Ben) (Warbucks Oliver)
; (Tweakit Lem E) (Bitdiddle Ben) (Warbucks Oliver)

; (Cratchet Robert) (Scrooge Eben) (Warbucks Oliver)
