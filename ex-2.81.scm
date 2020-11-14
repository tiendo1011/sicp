(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
       (let ((proc (get op type-tags)))
            (if proc
                (apply proc (map contents args))
                (if (= (length args) 2)
                    (let ((type1 (car type-tags))
                          (type2 (cadr type-tags))
                          (a1 (car args))
                          (a2 (cadr args)))
                         (let ((t1->t2 (get-coercion type1 type2))
                               (t2->t1 (get-coercion type2 type1)))
                              (cond (t1->t2
                                      (apply-generic op (t1->t2 a1) a2))
                                    (t2->t1
                                      (apply-generic op a1 (t2->t1 a2)))
                                    (else (error "No method for these types"
                                                 (list op type-tags))))))
                    (error "No method for these types"
                           (list op type-tags)))))))

(define (scheme-number->scheme-number n) n)
(define (complex->complex z) z)
(put-coercion 'scheme-number
              'scheme-number
              scheme-number->scheme-number)
(put-coercion 'complex 'complex complex->complex)

; a. What happens if we call exp with two complex numbers as arguments?
(exp z1 z2)
; apply-generic will be called with (apply-generic exp z1 z2),
; it try to find the proc for exp with z1, z2 but can't find it
; so it try the convert: type1: complex, type2: complex
; t1->t2 get-coercion complex complex, it finds one
; it calls (apply-generic exp z1 z2)
; => that's a loop
; b. It works correctly as it is
; c.

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
       (let ((proc (get op type-tags)))
            (if proc
                (apply proc (map contents args))
                (if (= (length args) 2)
                    (let ((type1 (car type-tags))
                          (type2 (cadr type-tags))
                          (a1 (car args))
                          (a2 (cadr args)))
                         (if (= type1 type2)
                             (error "No method for these types"
                                    (list op type-tags))
                             (let ((t1->t2 (get-coercion type1 type2))
                                   (t2->t1 (get-coercion type2 type1)))
                                  (cond (t1->t2
                                          (apply-generic op (t1->t2 a1) a2))
                                        (t2->t1
                                          (apply-generic op a1 (t2->t1 a2)))
                                        (else (error "No method for these types"
                                                     (list op type-tags)))))))
                    (error "No method for these types"
                           (list op type-tags)))))))
