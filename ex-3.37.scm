; The cumbersome version
(define (celsius-fahrenheit-converter c f)
  (let ((u (make-connector))
        (v (make-connector))
        (w (make-connector))
        (x (make-connector))
        (y (make-connector)))
       (multiplier c w u)
       (multiplier v x u)
       (adder v y f)
       (constant 9 w)
       (constant 5 x)
       (constant 32 y)
       'ok))

; The expression oriented style version
(define (celsius-fahrenheit-converter x)
  (c+ (c* (c/ (cv 9) (cv 5))
          x)
      (cv 32)))
(define C (make-connector))
(define F (celsius-fahrenheit-converter C))

; Define procedures:
(define (c+ x y)
  (let ((z (make-connector)))
       (adder x y z)
       z))

(define (c- x y)
  (let ((z (make-connector)))
       (adder z y x)
       z))

(define (c* x y)
  (let ((z (make-connector)))
       (multiplier x y z)
       z))

(define (c/ x y)
  (let ((z (make-connector)))
       (multiplier z y x)
       z))

(define (cv x)
  (let ((z (make-connector)))
       (constant x z)
       z))
