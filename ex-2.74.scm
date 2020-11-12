; division's personnel records consist of a single file
; a set of records keyed on employees' names
; Job - record 1
; Bill - record 2

; Each employee's record is itself a set contains information keyed under identifiers such as address & salary
; (
;  (Job ((Adress A) (Salary 1)))
;  (Bill ((Adress B) (Salary 2)))
; )

; a
(define (install-get-record-package)
  ;; internal procedures
  (define (get-record file employee-name)
    (let ((results (filter (lambda (x) (equal? (car x) employee-name)))))
      (if (null? results)
          (error "Employee name not found")
          (car results))))
  ;; interface to the rest of the system
  (put 'get-record 'division1 get-record)
  'done)

(define (get-record file employee-name)
  (let (type (car file))
    ((get 'get-record type) (cdr file) employee-name)))

; Individual divisions' files should have type at the beginning of the set
; type should be the name of the division
; (
;  division1
;  (Job ((Adress A) (Salary 1)))
;  (Bill ((Adress B) (Salary 2)))
; )

; b
(define (install-get-record-package)
  ;; internal procedures
  (define (get-salary employee-record)
    (let ((results (filter (lambda (x) (equal? (car x) 'salary)))))
      (if (null? results)
          (error "Salary not found")
          (car results))))
  ;; interface to the rest of the system
  (put 'get-salary 'division1 get-salary)
  'done

(define (get-salary employee-record)
  (let (type (car employee-record))
    ((get 'get-salary type) (cdr employee-record))))

; Individual record should have type at the beginning
; (
;  (division1 Job ((Adress A) (Salary 1)))
;  (division1 Bill ((Adress B) (Salary 2)))
; )

; c
(define (find-employee-record files employee-name)
  (for-each
    (lambda (file) (get-record file employee-name))
    files))

; d
; Just install a new get-record & get-salary for the newly aquired company
