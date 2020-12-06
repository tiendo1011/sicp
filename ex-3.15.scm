(define x (list 'a 'b))
(define z1 (cons x x))
(define z2 (cons (list 'a 'b) (list 'a 'b)))
(define (set-to-wow! x) (set-car! (car x) 'wow) x)
z1
(set-to-wow! z1)
z2
(set-to-wow! z2)
; Draw box-and-pointer diagrams to explain the effect of set-to-wow! on the structures z1 and z2 above.
; For z1, it set pointer of car of x to 'wow
; For z2, it set pointer of car of (car z2) to 'wow
