(define (install-scheme-number-package)
  (put '=zero? '(scheme-number scheme-number)
       (lambda (x) (= x 0)))
  'done)

(define (install-rational-package)
  (put '=zero? '(rational rational)
       (lambda (x) (= (numer x))))
  'done)

(define (install-complex-package)
  (put '=zero? '(scheme-number scheme-number)
       (lambda (x) (and
                       (= (real-part x) 0)
                       (= (imag-part x) 0))))
  'done)

(define (=zero? x) (apply-generic '=zero? x))
