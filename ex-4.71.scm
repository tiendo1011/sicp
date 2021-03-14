; From the book, without delay, it leads to some loop
; which doesn't print anything at all
; We can see it from the example below
(load "metacircular-evaluator-query-evaluator.scm")
(query-driver-loop)

(assert! (married Minnie Mickey))
(assert! (rule (married ?x ?y)
               (married ?y ?x)))
(married Mickey ?who)
