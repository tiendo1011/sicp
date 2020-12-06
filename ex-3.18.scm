; What is an cycle list: there is no end, the end's cdr point to the beginning of the list
; Maybe we can break the cycle first
; Let's pretend that we have a normal list: x, and a cycle list: y
; tempt-cdr-x = cdr x
; set-cdr! x = '()
; tempt-cdr-y = cdr y
; set-cdr! y = '()
; If we traverse tempt-cdr-y, we'll endup with y (last-pair tempt-cdr-y == y)
(load "list-operation.scm")
(define (cycle-list? x)
  (let ((temp-cdr-x (cdr x)))
    (set-cdr! x '())
    (eq? (last-pair temp-cdr-x) x)))

(define l1 (list 'a 'b))
(cycle-list? l1)
(define l2 (make-cycle (list 'a 'b)))
(cycle-list? l2)
