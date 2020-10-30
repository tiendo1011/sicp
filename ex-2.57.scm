(load "deriative.scm")

(define (augend s)
  (cond ((null? (cdddr s)) (caddr s))
        (else (cons '+ (cddr s)))))

(define (multiplicand p)
  (cond ((null? (cdddr p)) (caddr p))
        (else (cons '* (cddr p)))))

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        ((sum? exp) (make-sum (deriv (addend exp) var)
                              (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product (multiplier exp)
                         (deriv (multiplicand exp) var))
           (make-product (deriv (multiplier exp) var)
                         (multiplicand exp))))
        (else
          (error "unknown expression type: DERIV" exp))))

(deriv '(* x y (+ x 3)) 'x)
