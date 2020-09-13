(define (find-e-k n)
  (define (find-e-k-iter possible-k possible-e)
    (if (= (remainder possible-k 2) 0)
        (find-e-k-iter (/ possible-k 2) (+ possible-e 1))
        (values possible-e (exact-floor (log possible-k 3)))))
  (find-e-k-iter n 0))

(define (custom-cons a b)
  (* (expt 2 a) (expt 3 b)))

(define (custom-car z)
  (let-values (((a b) (find-e-k z)))
   a))

(define (custom-cdr z)
  (let-values (((a b) (find-e-k z)))
   b))

(define z (custom-cons 2 2))

(custom-car z)
(custom-cdr z)
