; a. Because number & variable are data type, they do not have operator & operands
; b.
(load "deriative.scm")
(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        (else ((get 'deriv (operator exp))
               (operands exp) var))))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (install-deriv-sum-package)
  ;; internal procedures
  (define (deriv-internal args var)
    (make-sum (deriv (car args) var)
              (deriv (cdr args) var)))
  ;; interface to the rest of the system
  (put 'deriv '+ deriv-internal)
  'done)

(define (install-deriv-product-package)
  ;; internal procedures
  (define (deriv-internal args var)
    (make-sum (make-product
                (car args)
                (deriv (cdr args) var))
              (make-product
                (deriv (car args) var)
                (cdr args))))
  ;; interface to the rest of the system
  (put 'deriv '* deriv-internal)
  'done)

; c
(define (install-deriv-exponentiation-package)
  ;; internal procedures
  (define (deriv-internal args var)
    (make-product
      (cdr args)
      (make-product
        (make-exponentiation (car args) (- (cdr args) 1))
        (deriv (car args) var))))
  ;; interface to the rest of the system
  (put 'deriv '** deriv-internal)
  'done)

; d: Change the put line
