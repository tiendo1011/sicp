(define (expt b n)
  (expt-iter b n 1))
(define (expt-iter b counter product)
  (cond ((= counter 0) product)
        ((= counter -1) (/ product b))
        (else (expt-iter b
                (- counter 2)
                (* (* b b) product)))))

(expt 2 5)
