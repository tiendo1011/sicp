(define (install-scheme-number-package)
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (equal? x y)))
  'done)

(define (install-rational-package)
  (put 'equ? '(rational rational)
       (lambda (x y) (equal? (* (numer x) (denom y))
                             (* (numer y) (denom x)))))
  'done)

(define (install-complex-package)
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (and
                       (equal? (real-part x) (real-part y))
                       (equal? (imag-part x) (imag-part y)))))
  'done)

(define (equ? x y) (apply-generic 'equ? x y))
