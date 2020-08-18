(define (find-smallest a b c)
    (cond ((and (>= a b) (>= b c)) c)
           ((and (>= a b) (< b c)) b)
           ((and (> b a) (>= a c)) c)
           (else a)))

(define (square a) (* a a))

(define (sum-of-squares x y)
  (+ (square x) (square y)))

(define (sum-of-two-largest-numbers-squared a b c)
  (define smallest (find-smallest a b c))
  (cond ((= smallest a) (sum-of-squares b c))
        ((= smallest b) (sum-of-squares a c))
        ((= smallest c) (sum-of-squares b c))))

(sum-of-two-largest-numbers-squared 1 4 3)
