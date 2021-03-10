(rule (can-replace ?person-1 ?person-2)
      (and
        (job ?person-1 ?job-1)
        (job ?person-2 ?job-2)
        (not (same ?person-1 ?person-2))
        (or (same ?job-1 ?job-2)
            (can-do-job ?job-1 ?job-2))))

; a. all people who can replace Cy D. Fect;
(can-replace ?x (Fect Cy D))

; b. all people who can replace someone who is being paid
; more than they are, together with the two salaries.
(and
  (can-replace ?x ?y)
  (salary ?x ?salary-1)
  (salary ?y ?salary-2)
  (lisp-value < ?x ?y))
