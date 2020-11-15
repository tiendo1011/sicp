; operation on sparse polynormials term-list
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
        term-list
        (cons term term-list)))
  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))
  (define (make-term order coeff) (list order coeff))

  (define (first-term-order term-list) (car (car term-list)))
  (define (coeff term) (cadr term))

; operation on dense polynormials term-list
(define (adjoin-term term term-list)
  (cons term term-list))
(define (the-empty-termlist) '())
(define (first-term term-list)
  (list (- (length term-list) 1) (car term-list)))
(define (rest-terms term-list) (cdr term-list))
(define (empty-termlist? term-list) (null? term-list))
(define (make-term order coeff) coeff)
(define (first-term-order term-list)
  (- (length term-list) 1))
(define (coeff term) term)

; The only procedures that is differed is order
; dense version requires term-list to determine the term order
; sparse version doesn't
; How to we generalize this?
; We pass both the term & the term-list to order
; or can sparse version extract the order from term-list?
; It seems like we can do just that
; order always act on the first time, so if we're passed a term-list, we can just extract the first term
; and get it's order
; we can rename it to first-term-order to express what it does
; Also, we need to tag the term-list with the type, and put the operations for each type into the table
; When we use them, we get the operation from the table
; since we also act on the term, we need to tag the term with the appropriate type, too
