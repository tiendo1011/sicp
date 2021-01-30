(define (install-and-package)
  ;; internal procedures
  (define (eval-and exp env)
    (let ((exps (cdr exp)))
         (cond ((null? exps) true)
               ((false? (eval (car exps) env)) false)
               (else (eval (cons 'and (cddr exps)) env)))))
  ;; interface to the rest of the system
  (put 'eval 'and eval-and)
  'done)

(define (install-or-package)
  ;; internal procedures
  (define (eval-or exp env)
    (let ((exps (cdr exp)))
         (cond ((null? exps) false)
               ((true? (eval (car exps) env)) true)
               (else (eval (cons 'or (cddr exps)) env)))))
  ;; interface to the rest of the system
  (put 'eval 'or eval-or)
  'done)

; implement "and" & "or" as derived expressions mean
; evaluate '(and exp1 exp2) without eval-and & eval-or

; expansion plan:
; (and exp1 exp2)
; will become:
; (if exp1
;     (if exp2
;        'true
;        'false)
;     'false)
(define (and? exp) (tagged-list? exp 'and))
(define (and-clauses exp) (cdr exp))
(define (and->if exp) (expand-and-clauses (and-clauses exp)))
(define (expand-and-clauses clauses)
  (if (null? clauses)
      'true
      (let ((first (car clauses))
            (rest (cdr clauses)))
           (make-if first
                    (expand-and-clauses rest)
                    'false))))

; expansion plan:
; (or exp1 exp2)
; will become:
; (if exp1
;     'true
;     (if exp2
;        'true
;        'false)
(define (or? exp) (tagged-list? exp 'or))
(define (or-clauses exp) (cdr exp))
(define (or->if exp) (expand-or-clauses (or-clauses exp)))
(define (expand-or-clauses clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
            (rest (cdr clauses)))
           (make-if first
                    'true
                    (expand-or-clauses rest)))))

; I added to metacircular-evaluator & run it and it works, yay!
