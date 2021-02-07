((lambda (n)
         ((lambda (fact) (fact fact n))
          (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))))
 10)

; To understand how it works
; Let's see how the code is evaluated with smaller number
((lambda (n)
         ((lambda (fact) (fact fact n))
          (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))))
 1)
; => return 1

((lambda (n)
         ((lambda (fact) (fact fact n))
          (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1)))))))
 2)

; (* 2 (fact fact 1))
; So it's recursively calls the smaller one

; Let's try f
(define (f x)
  ((lambda (even? odd?) (even? even? odd? x))
   (lambda (ev? od? n)
           (if (= n 0) true (od? ev? od? (- n 1))))
   (lambda (ev? od? n)
           (if (= n 0) false (ev? ev? od? (- n 1))))))

(f 3)
