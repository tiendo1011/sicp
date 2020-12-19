; (define (monadic? args)
;   (equal? (length args) 1))

; (define (dyadic? args)
;   (equal? (length args) 2))

; (define (build-list value . args)
;   (cond ((monadic? args) (error "Can't build list from a single arg"))
;         ((dyadic? args) (list (car args) (cons (cadr args) value)))
;         (else (list (car args) (apply build-list value (cdr args))))))

; (build-list 'value 'a 'b 'c)
