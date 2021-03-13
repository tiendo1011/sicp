; The original rule:
(rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
          (and (supervisor ?staff-person ?middle-manager)
               (outranked-by ?middle-manager ?boss))))

; The mis-type rule:
(rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
          (and (outranked-by ?middle-manager ?boss)
               (supervisor ?staff-person
                           ?middle-manager))))


(outranked-by (Bitdiddle Ben) ?who)

; Flow
; - Search db: no information
; - Search rule: there is one rule specifying this
; Unify the query & the rule conclusion
; ?staff-person -> (Bitdiddle Ben)
; ?boss -> ?who

; Evaluate the body
; (or (supervisor (Bitdiddle Ben) ?who)
;     (and (outranked-by ?middle-manager ?who)
;          (supervisor (Bitdiddle Ben) ?middle-manager)))

; For the or, the result is ?who instantiate with (Hacker Alyssa P), (Fect Cy D), (Tweakit Lem E)
; For the and, it calls outranked-by with ?middle-manager & ?who is unknown
; This print all the supervisor in the db
; And continue to call outranked-by with ?middle-manager & ?who is unknown
