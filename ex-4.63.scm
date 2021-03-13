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

(grandson Cain ?x)
(son Lamech ?x)
(grandson Methushael ?x)
