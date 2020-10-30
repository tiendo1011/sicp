; The idea is that sum? will returns true if there is one + in the group
; then addend will return the part before the +, augend return the part after the +
; product? return true if the list only contains *

(load "deriative.scm")
(load "list-operation.scm")

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2))
         (+ a1 a2))
        (else (list a1 '+ a2))))

(define (sum? x) (and (pair? x) (> (findIndex x '+) -1)))

(define (addend s)
  (let ((index (findIndex s '+)))
    (cond ((= 0 (- index 1)) (list-ref s 0))
          (else (slice s 0 (- index 1))))))

(define (augend s)
  (let ((index (findIndex s '+)))
    (cond ((= (+ index 1) (- (length s) 1)) (list-ref s (+ index 1)))
          (else (slice s (+ index 1) (- (length s) 1))))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

(define (product? x) (and (pair? x) (= (findIndex x '+) -1) (> (findIndex x '*) -1)))

(define (multiplier p) (car p))

(define (multiplicand p) (caddr p))

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

(deriv '(3 * (x + (y + 2)) + x) 'x)
