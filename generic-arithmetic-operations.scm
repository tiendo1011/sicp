(load "base.scm")
(load "two-dimentional-table.scm")
(load "list-operation.scm")

(define (attach-tag type-tag contents)
  (if (number? contents)
      contents
      (cons type-tag contents)))

(define (type-tag datum)
  (cond ((pair? datum) (car datum))
        ((number? datum) 'scheme-number)
        (else (error "Bad tagged datum: TYPE-TAG" datum))))

(define (contents datum)
  (cond ((pair? datum) (cdr datum))
        ((number? datum) datum)
        (else (error "Bad tagged datum: CONTENTS" datum))))

(define (apply-generic op . args)
  (p "op: " op " args: " args)
  (let ((type-tags (map type-tag args)))
       (let ((proc (get op type-tags)))
            (if proc
                (apply proc (map contents args))
                (error
                  "No method for these types: APPLY-GENERIC"
                  (list op type-tags))))))

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (=zero? x) (apply-generic '=zero? x))
(define (gcd x y) (apply-generic 'gcd x y))
(define (negate x) (apply-generic 'negate x))
(define (reduce x y) (apply-generic 'reduce x y))

(define (install-scheme-number-package)
  (define (tag x) (attach-tag 'scheme-number x))
  (define (gcd-scheme-number a b)
    (if (= b 0)
        a
        (gcd-scheme-number b (remainder a b))))

  (define (reduce-integers n d)
    (let ((g (gcd n d)))
         (list (/ n g) (/ d g))))

  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (tag (/ x y))))
  (put 'negate '(scheme-number)
       (lambda (x) (tag (- x))))
  (put '=zero? '(scheme-number)
       (lambda (x) (= x 0)))
  (put 'gcd '(scheme-number scheme-number)
       (lambda (a b) (tag (gcd-scheme-number a b))))
  (put 'reduce '(scheme-number scheme-number)
       (lambda (a b) (let ((reduced-integers (reduced-integers a b)))
                       (cons
                         (tag (car reduced-integers))
                         (tag (cadr reduce-integers))))))
  (put 'make 'scheme-number (lambda (x) (tag x)))
  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (reduce n d))
  (define (add-rat x y)
    (make-rat (add (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (sub (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (mul (numer x) (numer y))
              (mul (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (mul (numer x) (denom y))
              (mul (denom x) (numer y))))
  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'negate '(rational)
       (lambda (x) (tag (make-rat (- (numer x)) (denom x)))))
  (put '=zero? '(rational)
       (lambda (x) (= (numer x))))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))

(define (install-complex-package)
  ;; imported procedures from rectangular and polar packages
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                       (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
                       (- (angle z1) (angle z2))))
  ;; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'negate '(complex)
       (lambda (z) (tag (make-from-real-imag (- (real-part z)) (- (imag-part z))))))
  (put '=zero? '(complex)
       (lambda (x) (and
                     (= (real-part x) 0)
                     (= (imag-part x) 0))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

(define (install-polynomial-package)
  ;; internal procedures
  ;; representation of poly
  (define (make-poly variable term-list) (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))
  (define (=poly-zero? x)
    (null? (filter (lambda (x) (not (= (coeff x) 0))) (term-list x))))

  ;; representation of terms and term lists
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
        term-list
        (cons term term-list)))
  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))
  (define (make-term order coeff) (list order coeff))

  (define (order term) (car term))
  (define (coeff term) (cadr term))

  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (add-terms (term-list p1) (term-list p2)))
        (error "Polys not in same var: ADD-POLY" (list p1 p2))))

  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
            (let ((t1 (first-term L1))
                  (t2 (first-term L2)))
                 (cond ((> (order t1) (order t2))
                        (adjoin-term
                          t1 (add-terms (rest-terms L1) L2)))
                       ((< (order t1) (order t2))
                        (adjoin-term
                          t2 (add-terms L1 (rest-terms L2))))
                       (else
                         (adjoin-term
                           (make-term (order t1)
                                      (add (coeff t1) (coeff t2)))
                           (add-terms (rest-terms L1)
                                      (rest-terms L2)))))))))

  (define (sub-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (sub-terms (term-list p1) (term-list p2)))
        (error "Polys not in same var: SUB-POLY" (list p1 p2))))

  (define (sub-terms L1 L2)
    (cond ((empty-termlist? L1) (negate-terms L2))
          ((empty-termlist? L2) L1)
          (else
            (let ((t1 (first-term L1))
                  (t2 (first-term L2)))
                 (cond ((> (order t1) (order t2))
                        (adjoin-term
                          t1 (sub-terms (rest-terms L1) L2)))
                       ((< (order t1) (order t2))
                        (adjoin-term
                          (negate-term t2) (sub-terms L1 (rest-terms L2))))
                       (else
                         (adjoin-term
                           (make-term (order t1)
                                      (sub (coeff t1) (coeff t2)))
                           (sub-terms (rest-terms L1)
                                      (rest-terms L2)))))))))

  (define (negate-poly p)
    (make-poly (variable p) (negate-terms (term-list p))))

  (define (negate-terms L)
    (if (empty-termlist? L)
        L
        (adjoin-term
          (negate-term (first-term L))
          (negate-terms (rest-terms L)))))

  (define (negate-term t)
    (make-term (order t) (negate (coeff t))))

  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (mul-terms (term-list p1) (term-list p2)))
        (error "Polys not in same var: MUL-POLY" (list p1 p2))))
  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
        (the-empty-termlist)
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (let ((t2 (first-term L)))
             (adjoin-term
               (make-term (+ (order t1) (order t2))
                          (mul (coeff t1) (coeff t2)))
               (mul-term-by-all-terms t1 (rest-terms L))))))

  (define (div-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (div-terms (term-list p1) (term-list p2)))
        (error "Polys not in same var: DIV-POLY" (list p1 p2))))

  (define (div-terms L1 L2)
    (if (empty-termlist? L1)
        (list (the-empty-termlist) (the-empty-termlist))
        (let ((t1 (first-term L1))
              (t2 (first-term L2)))
             (if (> (order t2) (order t1))
                 (list (the-empty-termlist) L1)
                 (let ((new-c (div (coeff t1) (coeff t2)))
                       (new-o (- (order t1) (order t2))))
                      (let ((rest-of-result
                              (div-terms (sub-terms L1 (mul-term-by-all-terms (make-term new-o new-c) L2)) L2)))
                           (list
                             (adjoin-term (make-term new-o new-c) (car rest-of-result))
                             (cadr rest-of-result))))))))

  (put 'div-terms 'polynomial
       (lambda (x y)
               (div-terms x y)))

  (define (gcd-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (let* ((gcd-result (gcd-terms (term-list p1) (term-list p2)))
                          (factor (find-termlist-coeff-gcd gcd-result)))
                     (reduce-termlist-coeff-by-factor gcd-result factor)))
        (error "Polys not in same var: GCD-POLY" (list p1 p2))))

  (define (gcd-terms a b)
    (if (empty-termlist? b)
        a
        (gcd-terms b (pseudoremainder-terms a b))))

  (define (find-termlist-coeff-gcd termlist)
    (let* ((coefflist (map (lambda (term) (coeff term)) termlist)))
          (cond ((null? coefflist) (error "no element in termlist"))
                ((= (length coefflist) 1) (car coefflist))
                ((= (length coefflist) 2) (gcd (car coefflist) (cadr coefflist)))
                (else (gcd (car coefflist) (find-termlist-coeff-gcd (cdr termlist)))))))

  (define (reduce-termlist-coeff-by-factor termlist factor)
    (map (lambda (term) (make-term (order term) (div (coeff term) factor))) termlist))

  (define (remainder-terms a b)
    (cadr (div-terms a b)))

  (define (pseudoremainder-terms p q)
    (let* ((o1 (order (first-term p)))
           (o2 (order (first-term q)))
           (c (coeff (first-term q)))
           (integerizing-factor (expt c (sub (add 1 o1) o2))))
          (cadr (div-terms
                  (mul-term-by-all-terms
                    (make-term 0 integerizing-factor) p)
                  q))))

  (define (reduce-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (let ((reduced-terms (reduce-terms (term-list p1) (term-list p2))))
          (list (make-poly (variable p1) (car reduced-terms))
                (make-poly (variable p1) (cadr reduced-terms))))
        (error "Polys not in same var: REDUCE-POLY" (list p1 p2))))

  (define (reduce-terms n d)
    (let* ((gcd-n-d (gcd-terms n d))
           (o2 (order (first-term gcd-n-d)))
           (o1-n (order (first-term n)))
           (o1-d (order (first-term d)))
           (o1 (if (> o1-n o1-d)
                   o1-n
                   o1-d))
           (integerizing-factor (expt (coeff (first-term gcd-n-d)) (sub (add 1 o1) o2)))
           (numerator-terms (car (div-terms (mul-term-by-all-terms (make-term 0 integerizing-factor) n) gcd-n-d)))
           (denominator-terms (car (div-terms (mul-term-by-all-terms (make-term 0 integerizing-factor) d) gcd-n-d)))
           (factor (find-termlist-coeff-gcd (concat numerator-terms denominator-terms))))
         (list
           (reduce-termlist-coeff-by-factor numerator-terms factor)
           (reduce-termlist-coeff-by-factor denominator-terms factor))))

  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))
  (put 'add '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'sub '(polynomial polynomial)
       (lambda (p1 p2) (tag (sub-poly p1 p2))))
  (put 'mul '(polynomial polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'div '(polynomial polynomial)
       (lambda (p1 p2) (tag (div-poly p1 p2))))
  (put 'negate '(polynomial)
       (lambda (p) (tag (negate-poly p))))
  (put 'zero? '(polynomial)
       (lambda (x) (=poly-zero? x)))
  (put 'gcd '(polynomial polynomial)
       (lambda (p1 p2) (tag (gcd-poly p1 p2))))
  (put 'reduce '(polynomial polynomial)
       (lambda (p1 p2) (let ((reduced-poly (reduce-poly p1 p2)))
                        (cons
                          (tag (car reduced-poly))
                          (tag (cadr reduced-poly))))))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  'done)

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))

(install-scheme-number-package)
(install-rational-package)
(install-complex-package)
(install-polynomial-package)
