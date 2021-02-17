; Supporting let is integrated to metacircular-evaluator-analyze-then-execute.scm

(load "metacircular-evaluator-analyze-then-execute.scm")

(define the-global-environment (setup-environment))
(driver-loop)

(let ((var1 1) (var2 2))
  (+ var1 var2))
