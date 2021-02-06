#lang sicp

(define (m-eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp) (make-procedure (lambda-parameters exp)
                                       (lambda-body exp)
                                       env))
        ((let? exp) (m-eval (let->combination exp) env))
        ((let*? exp) (m-eval (let*->nested-lets exp) env))
        ((begin? exp)
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (m-eval (cond->if exp) env))
        ((and? exp) (m-eval (and->if exp) env))
        ((or? exp) (m-eval (or->if exp) env))
        ((application? exp)
         (m-apply (m-eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
          (error "Unknown expression type: EVAL" exp))))

(define (m-apply procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence
           (procedure-body procedure)
           (extend-environment
             (procedure-parameters procedure)
             arguments
             (procedure-environment procedure))))
        (else
          (error
            "Unknown procedure type: APPLY" procedure))))

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (m-eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

(define (eval-if exp env)
  (if (true? (m-eval (if-predicate exp) env))
      (m-eval (if-consequent exp) env)
      (m-eval (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps)
         (m-eval (first-exp exps) env))
        (else
          (m-eval (first-exp exps) env)
          (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
                       (m-eval (assignment-value exp) env)
                       env)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
    (m-eval (definition-value exp) env)
    env)
  'ok)

(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

(define (variable? exp)
  (symbol? exp))

(define (quoted? exp) (tagged-list? exp 'quote))
(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (assignment? exp) (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (definition? exp) (tagged-list? exp 'define))
(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp) ; formal parameters
                   (cddr exp)))) ; body
(define (make-definition variable value)
  (list 'define variable value))

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))
(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

; Expansion plan:
; (cond ((> x 0) x)
;       ((= x 0) (display 'zero) 0)
;       (else (- x)))
; will become:
; (if (> x 0)
;     x
;     (if (= x 0)
;         (begin (display 'zero) 0)
;         (- x)))

(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))
(define (cond-induction-syntax? clause) (equal? (cadr clause) '=>))
(define (cond-induction-syntax-proc clause) (caddr clause))
(define (cond->if exp) (expand-clauses (cond-clauses exp)))
(define (expand-clauses clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
            (rest (cdr clauses)))
           (if (cond-else-clause? first)
               (if (null? rest)
                   (sequence->exp (cond-actions first))
                   (error "ELSE clause isn't last: COND->IF"
                          clauses))
               (if (cond-induction-syntax? first)
                 ; first: ((assoc 'b '((a 1) (b 2))) => cadr)
                   (make-if (cond-predicate first)
                            (list (cond-induction-syntax-proc first) (cond-predicate first))
                            (expand-clauses rest))
                   (make-if (cond-predicate first)
                            (sequence->exp (cond-actions first))
                            (expand-clauses rest)))))))

(define (let? exp) (tagged-list? exp 'let))

; Expansion plan:
; (let ((var1 exp1)
;       ...
;       (varn expn))
;   body)
; to
; ((lambda (var1 ... varn)
;    body) exp1 ... expn)
(define (let->combination exp)
  (if (named-let? exp)
      (make-begin
        (list
            (make-definition
              (named-let-exp-variable exp)
              (make-lambda (named-let-exp-var-list exp) (named-let-exp-body exp)))
            (cons
              (make-lambda (named-let-exp-var-list exp) (named-let-exp-body exp))
              (named-let-exp-exp-list exp))))
      (cons (make-lambda (let-exp-var-list exp) (let-exp-body exp)) (let-exp-exp-list exp))))

(define (named-let-exp-variable exp)
  (cadr exp))

(define (named-let? exp)
  (not (pair? (cadr exp))))

(define (named-let-exp-body exp)
  (cdddr exp))

(define (named-let-exp-var-list exp)
  (extract-car (caddr exp)))

(define (named-let-exp-exp-list exp)
  (extract-cadr (caddr exp)))

(define (let-exp-body exp)
  (cddr exp))

(define (let-exp-var-list exp)
  (extract-car (cadr exp)))

(define (let-exp-exp-list exp)
  (extract-cadr (cadr exp)))

(define (extract-car list)
  (if (null? list)
    '()
    (cons (caar list) (extract-car (cdr list)))))

(define (extract-cadr list)
  (if (null? list)
    '()
    (cons (cadar list) (extract-cadr (cdr list)))))

(define (let*? exp) (tagged-list? exp 'let*))

; Expansion plan:
; (let* ((x 3)
;        (y x))
;       (* x y))
; becomes:
; (let ((x 3))
;   (let ((y x)) (* x y)))
(define (let*->nested-lets exp)
  (build-nested-let (cadr exp) (caddr exp)))

(define (build-nested-let var-list body)
  (if (null? var-list)
    body
    (list 'let (list (car var-list)) (build-nested-let (cdr var-list) body))))

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

(define (true? x)
  (not (eq? x false)))
(define (false? x) (eq? x false))

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))
(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

; Environment procedures
(define (enclosing-environment env) (cdr env))

(define (first-frame env) (car env))

(define the-empty-environment '())

(define (build-name-value-pair-list vars vals)
  (if (null? vars)
    '()
    (cons
      (cons (car vars) (car vals))
      (build-name-value-pair-list (cdr vars) (cdr vals)))))

(define (make-frame vars vals)
  (if (= (length vars) (length vals))
      (build-name-value-pair-list vars vals)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

(define (extend-environment vars vals base-env)
  (cons (make-frame vars vals) base-env))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan frame)
      (cond ((null? frame)
             (env-loop (enclosing-environment env)))
            ((eq? var (caar frame)) (cdar frame))
            (else (scan (cdr frame)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
             (scan frame))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan frame)
      (cond ((null? frame)
             (env-loop (enclosing-environment env)))
            ((eq? var (caar frame)) (set-cdr! (car frame) val))
            (else (scan (cdr frame)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable: SET!" var)
        (let ((frame (first-frame env)))
             (scan frame))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((original-frame (first-frame env)))
       (define (scan frame)
         (cond ((null? frame)
                (set-car! env (cons (cons var val) original-frame)))
               ((eq? var (caar frame)) (set-cdr! (car frame) val))
               (else (scan (cdr frame)))))
       (scan original-frame)))
; End of environment procedure

(define (setup-environment)
  (let ((initial-env
          (extend-environment (primitive-procedure-names)
                              (primitive-procedure-objects)
                              the-empty-environment)))
       (define-variable! 'true true initial-env)
       (define-variable! 'false false initial-env)
       initial-env))
(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))
(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cadr cadr)
        (list 'pair? pair?)
        (list 'cons cons)
        (list 'null? null?)
        (list 'assoc assoc)
        (list 'equal? equal?)
        (list '+ +)
        (list '= =)
        (list '- -)
        ))
(define (primitive-procedure-names)
  (map car primitive-procedures))
(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))
(define (apply-primitive-procedure proc args)
  (apply
    (primitive-implementation proc) args))
(define input-prompt
  ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")
(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
       (let ((output (m-eval input the-global-environment)))
            (announce-output output-prompt)
            (user-print output)))
  (driver-loop))
(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))
(define (announce-output string)
  (newline) (display string) (newline))
(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))

(define the-global-environment (setup-environment))
(driver-loop)

(define (append x y)
  (if (null? x)
      y
      (cons (car x) (append (cdr x) y))))
(append '(a b c) '(d e f))
(and true false false)
(and true true true)
(or true false false)
(or true true true)
(cond ((equal? 1 1) 1)
      ((assoc 'b '((a 1) (b 2))) => cadr)
      (else false))
(cond ((equal? 1 2) 1)
      ((assoc 'b '((a 1) (b 2))) => cadr)
      (else false))
(let ((var1 1) (var2 2))
  (+ 1 2))
(let* ((x 3)
       (y x))
      (+ x y))
(define (fib n)
  (let fib-iter ((a 1)
                 (b 0)
                 (count n))
       (if (= count 0)
           b
           (fib-iter (+ a b) a (- count 1)))))
(fib 7)
