; Design a register machine to compute factorials
; using the iterative algorithm specified by the following
; procedure. Draw data-path and controller diagrams for this machine.
(define (factorial n)
  (define (iter product counter)
    (if (> counter n)
        product
        (iter (* counter product)
              (+ counter 1))))
  (iter 1 1))

; This is actually a combination of 2 smaller procedure:
  (define (iter product counter)
    (if (> counter n)
        product
        (iter (* counter product)
              (+ counter 1))))
; and the wrapper around it:
(define (factorial n)
  (iter-definition)
  (iter 1 1))

; The first one is basically the same as gcd
; So it's pretty similar, the only difference is the controller starts by
; assigning 1 to product & counter
