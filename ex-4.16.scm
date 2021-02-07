(load "list-operation.scm")

; This is already integrated into metacircular-evaluator
; Here is for testing its correctness
(define (first-var-in-var-exp-pairs var-exp-pairs)
  (caar var-exp-pairs))

(define (first-exp-in-var-exp-pairs var-exp-pairs)
  (cdar var-exp-pairs))

(define (make-unassigned-var var)
  (cons var '*unassigned*))

(define (make-let-params var-exp-pairs)
  (if (null? var-exp-pairs)
    '()
    (cons
      (make-unassigned-var (first-var-in-var-exp-pairs var-exp-pairs))
      (make-let-params (cdr var-exp-pairs)))))

(define (first-var-in-proc-body proc-body)
  (cadar proc-body))

(define (first-exp-in-proc-body proc-body)
  (caddar proc-body))

(define (make-var-exp-pair var exp)
  (cons var exp))

(define (scan-defines proc-body)
 (cond ((null? proc-body) '())
  ((eq? (caar proc-body) 'define)
   (cons
     (make-var-exp-pair (first-var-in-proc-body proc-body) (first-exp-in-proc-body proc-body))
     (scan-defines (cdr proc-body))))
  (else (scan-defines (cdr proc-body)))))

(define (scan-non-define-exps proc-body)
 (cond ((null? proc-body) '())
  ((not (eq? (caar proc-body) 'define))
   (cons
     (car proc-body)
     (scan-non-define-exps (cdr proc-body))))
  (else (scan-non-define-exps (cdr proc-body)))))

(define (make-set var exp)
  (list 'set! var exp))

(define (build-set-var-to-exp-list var-exp-pairs)
  (if (null? var-exp-pairs)
    '()
    (cons
      (make-set (first-var-in-var-exp-pairs var-exp-pairs) (first-exp-in-var-exp-pairs var-exp-pairs))
      (build-set-var-to-exp-list (cdr var-exp-pairs)))))

(define (make-let-bodys var-exp-pairs proc-body)
  (concat
    (build-set-var-to-exp-list var-exp-pairs)
    (scan-non-define-exps proc-body)))

(define (scan-out-defines proc-body)
  (let ((defined-var-exp-pairs (scan-defines proc-body)))
    (make-let
      (make-let-params defined-var-exp-pairs)
      (make-let-bodys defined-var-exp-pairs proc-body))))

(define (make-let params body)
  (cons 'let (cons params body)))

(define original-body (list (list 'define 'u 1) (list 'define 'v 2) (list '* 'u 'v) (list '+ 'u 'v)))
(display (scan-out-defines original-body))

; c: Install scan-out-defines in the interpreter, either in
; make-procedure or in procedure-body (see Section
; 4.1.3). Which place is better? Why?
; One is called when we make the proc,
; One is called when we call the proc
; Since we call proc much more often than making them
; it's more efficient to put them inside make-procedure
