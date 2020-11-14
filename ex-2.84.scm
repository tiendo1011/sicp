(define (coerce-args args n)
  (let* ((target-arg (list-ref args n))
        (target-arg-type (type-tag target-arg)))
    (map (lambda (arg) (coerce arg target-arg-type)) args)))

; Modified here
(define (coerce arg type)
  (cond ((= (type-tag arg) type) arg)
        ((higher? (type-tag arg) type) (error "no coercion method found"))
        (else (coerce ((get 'raise (type-tag arg)) arg) type)))) ; Assume that if the arg type is lower than type then
                                                                 ; Will always be a way to raise it up

; Assume that the package installs the tower as a list (list 'integer 'rational 'real 'complex)
(define (higher? type1 type2)
  (let ((type1-index (find-index tower type1))
        (type2-index (find-index tower type2)))
    (cond ((= type1-index -1) (error "invalid type: " type1))
          ((=type2-index -1) (error "invalid type: " type2))
          (else (> (find-index tower type1) (find-index tower type2))))))

; Searching from the internet
; There is a way that's kinda the same but avoid having to find-index
 (define (level type)
   (cond ((eq? type 'integer) 0)
         ((eq? type 'rational) 1)
         ((eq? type 'real) 2)
         ((eq? type 'complex) 3)
         (else (error "Invalid type: LEVEL" type))))

(define (same-type? type-tags)
  (let ((first-type-tag (list-ref type-tags 0)))
    (null? (filter (lambda (x) (not (equal? x first-type-tag))) type-tags))))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
       (let ((proc (get op type-tags)))
            (if proc
                (apply proc (map contents args))
                (if (same-type? type-tags)
                    (error "No method found for" (list op type-tags))
                    (for-each-with-index
                      (lambda (arg, index)
                              (let ((coerced-args (coerce-args args index)))
                                   (apply-generic op coerced-args)))
                      args))))))
