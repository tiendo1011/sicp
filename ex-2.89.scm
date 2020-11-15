; Define procedures that implement the term-
; list representation described above as appropriate for dense polynomials.

; One thing to keep in mind, is that the return value should be the same as the original representation

(define (adjoin-term term term-list)
  (cons term term-list))
(define (the-empty-termlist) '())
(define (first-term term-list)
  (list (- (length term-list) 1) (car term-list)))
(define (rest-terms term-list) (cdr term-list))
(define (empty-termlist? term-list) (null? term-list))
(define (make-term order coeff) coeff)
(define (order term-list)
  (- (length term-list) 1))
(define (coeff term) term)
