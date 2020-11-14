(load "list-operation.scm")

; we need an operation that takes a args and
; coerce the arguments' type to the argument #n type, n is provided
; Why get-coercion? So that we can coerce the type
; If there are none => no method
; arg1 arg2 arg3 1
; arg2->arg1 if found coerce arg2 to arg1
; arg3->arg1 if found coerce arg3 to arg1
; the results? args with arg1 type

; coerce-args pseudocode
; get arg #n, get type
; map through args #n, try to coerce them to arg #n type
(define (coerce-args args n)
  (let* ((target-arg (list-ref args n))
        (target-arg-type (type-tag target-arg)))
    (map (lambda (arg) (coerce arg target-arg-type)) args)))

(define (coerce arg type)
  (if (= (type-tag arg) type)
      arg
      (let ((coercion-method (get-coercion (type-tag arg) type)))
         (if (not coercion-method)
             (error "no coercion method found for" (list arg type))
             (coercion-method arg)))))

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

; Give an example of a situation where this strategy (and likewise the two-argument version given above)
; is not sufficiently general.
; (Hint: Consider the case where there are some suitable mixed-type
; operations present in the table that will not be tried.
; Maybe for example we have scheme-number->complex but we don't have complex->scheme-number
; So if we try complex->scheme-number it will fail
; scheme-number->complex works but it is not tried
