; equal? pseudocode
; null? a
;   null? b: true
;   not (null? b): false
; not (null? a) && not (pair? a)
;   null? b: false
;   pair? b: false
;   not (pair? b): eq? a b
; not (null? a) && pair? a
;   null? b: false
;   not (pair? b): false
;   pair? b: (eq? (car a) (car b)) && equal? (cdr a) (cdr b)

(define (equal? a b)
  (cond ((null? a) (cond
                     ((null? b) true)
                     (else false)))
        ((and (not (null? a)) (not (pair? a))) (cond
                                                 ((null? b) false)
                                                 ((pair? b) false)
                                                 (else (eq? a b))))
        (else (cond
                ((null? b) false)
                ((not (pair? b)) false)
                (else (and (eq? (car a) (car b)) (equal? (cdr a) (cdr b))))))))

(equal? '(this is a list) '(this (is a) list))
