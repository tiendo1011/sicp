(define (cons x y)
  (define (set-x! v) (set! x v))
  (define (set-y! v) (set! y v))
  (define (dispatch m)
    (cond ((eq? m 'car) x)
          ((eq? m 'cdr) y)
          ((eq? m 'set-car!) set-x!)
          ((eq? m 'set-cdr!) set-y!)
          (else
            (error "Undefined operation: CONS" m))))
  dispatch)
(define (car z) (z 'car))
(define (cdr z) (z 'cdr))
(define (set-car! z new-value)
  ((z 'set-car!) new-value) z)
(define (set-cdr! z new-value)
  ((z 'set-cdr!) new-value) z)

; 1. (define x (cons 1 2))
; 1.1 (cons 1 2)
; evaluate in E1
; binds x to 1, y to 2
; evaluate the body:
; binds set-x! to a procedure object
; binds set-y! to a procedure object
; binds dispatch to a procedure object
; returns dispatch
; enclosing env of those procedure objects: E1

; 1.2: evaluate (define x dispatch-procedure-object)
; binds x to the dispatch-procedure-object

; 2. (define z (cons x x))
; 2.1 (cons x x)
; evaluate in E2
; binds x to dispatch procedure object, y to dispatch procedure object
; evaluate the body
; binds set-x! to a procedure object
; binds set-y! to a procedure object
; binds dispatch to a procedure object
; returns dispatch
; enclosing env of those procedure objects: E2

; 2.2 (define z dispatch-procedure-object)

; 3. (set-car! (cdr z) 17)
; 3.1 evaluate (cdr z) in E3
; binds dispatch-procedure-object to z
; evaluate the body (z 'cdr) in E3
; (z has E2 as enclosing env, where it is defined)
; binds m to 'cdr
; evaluate dispatch body:
; returns y, Where does it find y? (in E2)
; y is dispatch procedure object defined which has enclosing env E1

; 3.2 (set-car! dispatch-procedure-object 17)
; ((dispatch-procecure-object 'set-car!) 17) dispatch-procedure-object)
; (set-x! 17) in E1 => change x in E1 to 17

; 4. (car x)
; (x 'car) => x value in E1 => 17
