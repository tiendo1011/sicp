(load "list-operation.scm")
(load "base.scm")

(define counted-pairs '())

(define (counted? x)
  (any? counted-pairs (lambda (c) (eq? c x))))

; Follow the hint from the book: Traverse the structure,
; maintaining an auxiliary data structure that is used to keep
; track of which pairs have already been counted.
; The idea is pretty simple, yet implement it rock my knowledge about pair & list to the core
(define (count-pairs x)
  (cond ((not (pair? x)) 0)
        ((counted? x) 0)
        (else (begin
                (set! counted-pairs (cons x counted-pairs)))
                (+ (count-pairs (car x))
                   (count-pairs (cdr x))
                   1)))))

(define c (list 'c))
(define l2 (cons 'a (cons c c)))
(count-pairs l2) ; 3

(define c (list 'c))
(define b (cons c c))
(define l3 (cons b b))
(count-pairs l3) ; 3
