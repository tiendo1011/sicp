; a. the names of all people who are supervised by Ben Bitdiddle,
; together with their addresses;

(and (supervisor ?x (Ben Bitdiddle))
     (address ?x ?y))

; b. all people whose salary is less than Ben Bitdiddle’s,
; together with their salary and Ben Bitdiddle’s salary;
(and
  (salary (Ben Bitdiddle) ?ben-salary)
  (salary ?person ?amount)
  (lisp-value < ?amount ?ben-salary))

; c. all people who are supervised by someone who is not
; in the computer division, together with the supervi-
; sor’s name and job.
(and
 (not (job ?not-computer-division-person (computer ?type)))
 (supervisor ?person ?not-computer-division-person))
