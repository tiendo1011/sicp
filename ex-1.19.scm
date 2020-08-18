(define (remainder a b)
  (if (< a b)
      a
      (remainder (- a b) b)))

(define (even? n)
  (= (remainder n 2) 0))

(define (fib n)
  (fib-iter 1 0 0 1 n))
(define (fib-iter a b p q count)
  (cond ((= count 0) b)
        ((even? count)
            (fib-iter a
                      b
                      (+ (* p p) (* q q)); compute p ′
                      (+ (* q q) (* 2 p q)); compute q ′
                      (/ count 2)))
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))

(fib 7)
