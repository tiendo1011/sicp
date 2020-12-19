; We'll implement for one dimentional table only
(*table* (a . 1) (b . 2) (c . 3))

(load "base.scm")

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define (key val) (car val))

(define (assoc given-key set-of-records)
  (cond ((null? set-of-records) false)
        ((equal? given-key (key (entry set-of-records)))
         (entry set-of-records))
        ((< given-key (key (entry set-of-records)))
         (assoc given-key (left-branch set-of-records)))
        (else (assoc given-key (right-branch set-of-records)))))

(define (lookup given-key table)
  (let ((record (assoc given-key (cdr table))))
       (if record
           (cdr record)
           false)))

(define (insert-to-records record set-of-records)
  (if (null? set-of-records)
      (make-tree record '() '())
      (let ((given-key (car record))
            (given-value (cdr record))
            (entry-key (key (entry set-of-records))))
           (cond ((equal? given-key entry-key)
                  (make-tree
                    record
                    left-branch
                    right-branch))
                 ((< given-key entry-key)
                  (make-tree
                    (entry set-of-records)
                    (insert-to-records record (left-branch set-of-records))
                    (right-branch set-of-records)))
                 ((> given-key entry-key)
                  (make-tree
                    (entry set-of-records)
                    (left-branch set-of-records)
                    (insert-to-records record (right-branch set-of-records))))))))

(define (insert! given-key value table)
  (let* ((record (cons given-key value))
         (new-tree-body (insert-to-records record (cdr table))))
    (set-cdr! table new-tree-body))
  'ok)

(define (make-table)
  (list '*table*))

(define operation-table (make-table))
(insert! 1 'a operation-table)
(display operation-table)
(insert! 2 'b operation-table)
(display operation-table)
(insert! 3 'c operation-table)
(display operation-table)
(lookup 3 operation-table)
