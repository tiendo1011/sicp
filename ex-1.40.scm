(load "newtons-method.scm")

(define (cubic a b c)
  (lambda (x) (+ (cube x) (* a (square x)) (* b x) c)))

; (newtons-method (cubic 2 1 1) 1)

; Test the result, should be ~ 0: ((cubic 2 1 1) -1.7548776662280976)
