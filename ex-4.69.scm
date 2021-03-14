(load "metacircular-evaluator-query-evaluator.scm")
(query-driver-loop)

(assert! (son Adam Cain))
(assert! (son Cain Enoch))
(assert! (son Enoch Irad))
(assert! (son Irad Mehujael))
(assert! (son Mehujael Methushael))
(assert! (son Methushael Lamech))
(assert! (wife Lamech Ada))
(assert! (son Ada Jabal))
(assert! (son Ada Jubal))

(assert! (rule (grandson ?g ?s)
      (and
        (son ?g ?f)
        (son ?f ?s))))

(assert! (rule (son ?m ?s)
      (and
        (wife ?m ?w)
        (son ?w ?s))))

(assert! (rule (end-in-grandson (grandson))))
(assert! (rule (end-in-grandson (great . ?rels))
               (end-in-grandson ?rels)))

(assert! (rule ((grandson) ?g ?s)
               (grandson ?g ?s)))

; My first attempt
(assert! (rule ((great . ?rel) ?x ?y)
               (and
                 (end-in-grandson ?rel)
                 (?rel ?x ?z)
                 (son ?z ?y))))

; My final attempt (Notice the position of (end-in-grandson ?rel) & (son ?z ?y) has been swapped
; See the explanation below for more details
(assert! (rule ((great . ?rel) ?x ?y)
               (and
                 (son ?z ?y)
                 (?rel ?x ?z)
                 (end-in-grandson ?rel))))

((great grandson) ?g ?ggs)
((great great grandson) ?g ?ggs)
(?relationship Adam Jabal) ; This leads to a loop that I don't know how to solve at first
; Let's see how the pattern matching work:
; - Search in db: No relationship between Adam & Jabal
; - One rule apply: ((great . ?rel) ?x ?y)
; => ?x is mapped to Adam, ?y is mapped to Jabal, ?rel is unknown
;  end-in-grandson ?rel is unknown
;  (?rel Adam ?z) & (son ?z Jabal)
; => z is Ada/Lamech
;    (?rel Adam Ada/Lamech)
; But we can only know this if (son ?z Jabal) runs first, and I don't think the
; query evaluator knows it
; So I think the better order is we put the one that we can determine first, like:
; (son ?z ?y)
; (?rel ?x ?z)
; (end-in-grandson ?rel)
; And turns out it works
