(define (m-eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        (else ((get 'eval (car exp)) exp env))))

(define (install-quoted-package)
  ;; internal procedures
  (define (text-of-quotation exp env)
    (cadr exp))
  ;; interface to the rest of the system
  (put 'eval 'quote text-of-quotation)
  'done)

(define (install-assignment-package)
  ;; internal procedures
  (define (eval-assignment exp env)
    (set-variable-value! (assignment-variable exp)
                         (m-eval (assignment-value exp) env)
                         env))
  ;; interface to the rest of the system
  (put 'eval 'set! eval-assignment)
  'done)

(define (install-definition-package)
  ;; internal procedures
  (define (eval-definition exp env)
    (define-variable! (definition-variable exp)
      (m-eval (definition-value exp) env)
      env))
  ;; interface to the rest of the system
  (put 'eval 'define eval-definition)
  'done)

; ... Similar for other packages
; data-directed style
; Which means put operation & type to a table like this:
;                           type
;      |------------------------------
; ope- | operation-1 | type-1 |  type-2
; rat- | ------------------------------
; ion  | operation-2 | type-1 |  type-2

; put 'operation-1 'type-1 proc-1
; put 'operation-1 'type-2 proc-2
; put 'operation-2 'type-1 proc-3
; put 'operation-2 'type-2 proc-4

; Then using tags (operation, type) to get to the corresponding proc

; For eval package, which means:
; eval | quote | set | define ...
