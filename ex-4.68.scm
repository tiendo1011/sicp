(load "metacircular-evaluator-query-evaluator.scm")
(query-driver-loop)

(assert! (rule (append-to-form () ?y ?y)))
(assert! (rule (append-to-form (?u . ?v) ?y (?u . ?z))
      (append-to-form ?v ?y ?z)))

(assert! (rule (q-reverse (?u ?v) (?v ?u))))
(assert! (rule (q-reverse (?u . ?v) ?z)
               (and (q-reverse ?v ?x)
                    (append-to-form ?x ?u ?z))))

(q-reverse (1 2 3) ?x)
