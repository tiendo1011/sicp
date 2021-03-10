(rule (lives-near ?person-1 ?person-2)
      (and (address ?person-1 (?town . ?rest-1))
           (address ?person-2 (?town . ?rest-2))
           (not (same ?person-1 ?person-2))))

(rule (same ?x ?x))

; Q: Why does this happen?
; A: Because A lives-near B also mean B lives-near A

; Q: Is there a way to find a list of people
; who live near each other, in which each pair appears only
; once? Explain.
; A: Yes, if we enforce some order, like the first character of A has to come before B
