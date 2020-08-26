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

; Carmichael numbers: 561, 1105, 1729, 2465, 2821, and 6601
; (not prime, but pass the Fermat's Little Theorem, have the property that
; a^n is congruent to a modulo n for all integers a < n)
; Normally, only prime has that property
; For non prime numbers, in general, most of the numbers a < n will not satisfy the
; Fetmat's Little Theorem relation

(define (fermat-test n)
  (define (try-it a)
    (if not (= (expmod a n n) a)
        (display a))
    (if (< a (- n 1))
        (try-it (+ a 1))
        (display "done")))
  (try-it 1))

(fermat-test 561)
(fermat-test 1105)
(fermat-test 1729)
(fermat-test 2465)
(fermat-test 2821)
(fermat-test 6601)
