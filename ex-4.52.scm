(load "metacircular-evaluator-amb-evaluation.scm")
(driver-loop)

(define (require p) (if (not p) (amb)))

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(if-fail (let ((x (an-element-of '(1 3 5))))
              (require (even? x))
              x)
         'all-odd)
