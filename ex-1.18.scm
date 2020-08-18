(define (multiply b n)
  (multiply-iter b n 0))
(define (multiply-iter b counter product)
  (cond ((= counter 0) product)
        ((= counter -1) (- product b))
        (else (multiply-iter b
                (- counter 2)
                (+ (+ b b) product)))))

(multiply 2 5)
