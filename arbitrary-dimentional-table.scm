; pattern:
; 1 dimention: Find value using key
; 2 dimention: Find value-1 using key-1, then find value-2 using key-2 from value-1
; arbitrary: Find value-1 using key-1,
;            then find value-2 using key-2 from value-1
;            then find value-3 using key-3 from value-2
; => lookup needs to receive different table each time

(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (monadic? args)
  (equal? (length args) 1))

(define (dyadic? args)
  (equal? (length args) 2))

(define (lookup table . args)
  (let* ((key (car args)))
        (cond ((monadic? args)
               (let ((record (assoc key (cdr table))))
                    (if record
                        (cdr record)
                        false)))
              (else
                (let ((subtable (assoc key (cdr table))))
                     (if subtable
                         (apply lookup subtable (cdr args))
                         false))))))

(define (build-list value . args)
  (cond ((monadic? args) (error "Can't build list from a single arg"))
        ((dyadic? args) (list (car args) (cons (cadr args) value)))
        (else (list (car args) (apply build-list value (cdr args))))))

(define (insert! table value . args)
  (let ((key (car args)))
       (cond ((monadic? args)
              (let ((record (assoc key (cdr table))))
                   (if record
                       (set-cdr! record value)
                       (set-cdr! table
                                 (cons (cons key value)
                                       (cdr table))))))
             (else
               (let ((subtable (assoc key (cdr table))))
                    (if subtable
                        (apply insert! subtable value (cdr args))
                        (set-cdr! table
                                  (cons (apply build-list value args)
                                        (cdr table)))))))))

(define (make-table)
  (list '*table*))
