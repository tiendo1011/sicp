(define (remainder a b)
  (if (< a b)
      a
      (remainder (- a b) b)))

(define (even? n)
  (= (remainder n 2) 0))

(define (double x) (+ x x))
(define (halve x) (/ x 2))

(define (* a n)
  (cond ((= n 0) 0)
        ((= n 1) a)
        ((even? n) (double(* a (/ n 2))))
        (else (+ a (* a (- n 1))))))

(* 2 4)
