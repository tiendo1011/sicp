; The version in the text (1):

(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env) (proc1 env) (proc2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
        first-proc
        (loop (sequentially first-proc (car rest-procs))
              (cdr rest-procs))))
  (let ((procs (map analyze exps)))
       (if (null? procs) (error "Empty sequence: ANALYZE"))
       (loop (car procs) (cdr procs))))

; Alyssa version (2):
(define (analyze-sequence exps)
  (define (execute-sequence procs env)
    (cond ((null? (cdr procs))
           ((car procs) env))
          (else
            ((car procs) env)
            (execute-sequence (cdr procs) env))))
  (let ((procs (map analyze exps)))
       (if (null? procs)
           (error "Empty sequence: ANALYZE"))
       (lambda (env)
               (execute-sequence procs env))))

; For a sequence with one expression:
; version 1 will return first-proc, which is an analyzed proc
; version 2 will return (lambda (env) (execute-sequence procs env))
; when called, will loop through the exp and calls them
; so while version 1 only needs to call first-proc, version 2 has to call execute-sequence repeatedly
; every time it's evaluated

; For a sequence with two expression:
; version 1 will return
; (sequentially first-proc second-proc)
; which is (lambda (env) (first-proc env) (second-proc env))

; version 2 will return
; (lambda (env) (execute-sequence procs env))

; In summary, version 2 does not analyze (execute-sequence procs env) call, so it's
; executed every time the sequence is evaluated
