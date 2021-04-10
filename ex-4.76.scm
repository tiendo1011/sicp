(load "base.scm")
(load "two-dimentional-table.scm")
(load "stream.scm")
(load "metacircular-evaluator-query-evaluator.scm")

(define (conjoin conjuncts frame-stream)
  (cond ((empty-conjunction? conjuncts) the-empty-stream)
        ((single-conjunction? conjuncts) (qeval (first-conjunct conjuncts) frame-stream))
        (else (unify-frame-streams
                (qeval (first-conjunct conjuncts) frame-stream)
                (conjoin (rest-conjuncts conjuncts) frame-stream)))))

(put 'and 'qeval conjoin)

(define (single-conjunction? exps) (and (pair? exps) (null? (cdr exps))))

(define (unify-frame-streams s1 s2)
  (if (stream-null? s1)
      the-empty-stream
      (interleave-delayed
        (unify-frame-with-frame-stream (stream-car s1) s2)
        (delay (unify-frame-streams (stream-cdr s1) s2)))))

(define (unify-frame-with-frame-stream f1 s2)
  (if (stream-null? s2)
    the-empty-stream
    (let ((unified-result (unify-frames f1 (stream-car s2))))
      (if (equal? unified-result 'failed)
          (unify-frame-with-frame-stream f1 (stream-cdr s2))
          (cons-stream
            unified-result
            (unify-frame-with-frame-stream f1 (stream-cdr s2)))))))

(define (unify-frames f1 f2)
  (cond ((pair? f1)
         (let ((unified-result (unify-match (binding-variable (car f1)) (binding-value (car f1)) f2)))
           (if (equal? unified-result 'failed)
             'failed
             (unify-frames
               (cdr f1)
               unified-result))))
        (else f2)))

(query-driver-loop)

(assert! (job (Bit Ben) (computer wizard)))
(assert! (job (Bitdiddle Ben) (computer wizard)))
(assert! (address (Bitdiddle Ben) (Slumerville (Ridge Road) 10)))
; (job ?x ?y)
(and (job ?x ?y) (address ?x ?z))
(and (job ?x ?y) (address ?x ?y))
