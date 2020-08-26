(load "square.scm")

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
          (remainder
            (square (expmod base (/ exp 2) m)) ; (1)
            m))
        (else
          (remainder
            (* base (expmod base (- exp 1) m))
            m))))

; (1) is based on the fact that for any integers x, y and m, we can
; find the remainder of x times y modulo m by computing separately the
; remainders of x modulo m and y modulo m, multiplying these, and then
; taking the remainder of the result modulo m
; ========= Prove ===========
; Let x = m.a + b; y = m.c + d
; x.y % m => (m.a + b)(m.c + d) % m => b.d % m

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))
