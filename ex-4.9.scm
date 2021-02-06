; I think I'll just add "for" iteration
; exp form (copy from DrRacket doc https://docs.racket-lang.org/guide/for.html):
; but I edit it a bit, from ([i '(1 2 3)]) to (i '(1 2 3))
; since the book doesn't mention the [ ] syntax
; and support it seems a bit out of scope

(for (i '(1 2 3))
    (display i))

; => Transfrom the call to for to a normal if

(define for-variable (caadr exp))
(define for-body (caddr exp))
(define (first-val a-list) (car a-list))
(define (rest-val a-list) (cdr a-list))
(lambda (for a-list)
  (if (not (null? a-list))
    (begin
      (for-body (first-val a-list))
      (eval (for (res-val a-list))))))
