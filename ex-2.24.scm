(load "list-operation.scm")

(define list-1 (list 1 (list 2 (list 3 4))))
; Here is mine, using Racket
; (mcons 1 (mcons (mcons 2 (mcons (mcons 3 (mcons 4 '())) '())) '()))
; Yours can be different
; My assumption is that Racket will use the recommended form (by reference or something)
; Which is likely the same as mentioned by the book

(define list-2 (list 2 (list 3 4)))
(define list-3 (list 3 4))
(length list-3) ; 2

(length list-2) ; 2
; Helper, add list-2a, using cons instead of list and see how it goes
; also (cons (list 1 2) (list 3 4)) has length 3
(define list-2a (cons 2 (list 3 4)))
(length list-2a) ; 3

(length list-1) ; 2
