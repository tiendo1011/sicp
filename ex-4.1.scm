; left to right
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (left-right-cons (first-operand exps) (lambda () (list-of-values (rest-operands exps))) env)))

(define (left-right-cons exp1 exp2 env)
  (let ((arg1 (eval exp1 env))
        (arg2 (eval exp2 env)))
    (cons arg1 arg2)))

; right to left
(define (right-left-cons exp1 exp2 env)
  (let ((arg2 (eval exp2 env))
        (arg1 (eval exp1 env)))
    (cons arg1 arg2)))
