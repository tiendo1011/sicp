; Demonstrate that Lem is right
; par1 & par2 produce different results
; r1, r2

(load "interval-arithmetic.scm")

(define r1 (make-interval 100 102))
(define r2 (make-interval 50 51))

(par1 r1 r2)
(par2 r1 r2)

; Investigate the behavior A/A, A/B
(add-interval r1 r1)
(sub-interval (add-interval r1 r1) r1)
(sub-interval (add-interval (sub-interval (add-interval r1 r1) r1) r1) r1)
(mul-interval r1 r1)
(div-interval (mul-interval r1 r1) r1)
(div-interval (mul-interval (div-interval (mul-interval r1 r1) r1) r1) r1)

(div-interval r1 r2)

; Examine the results of the computation in center-percent form
(define r3 (make-center-percent 6.8 10))
(define r4 (make-center-percent 4.7 5))

(par1 r3 r4)
(par2 r3 r4)
