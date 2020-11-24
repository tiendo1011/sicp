; The answer is embeded inside generic-arithmetic-opeations.scm

(load "generic-arithmetic-operations.scm")

; For b.
; First, we need a proc that can find gcd of a list
; The idea is that (gcd 1 2 3) = (gcd 1 (gcd 2 3))
((get 'termlist-coeff-gcd 'i) '())
((get 'termlist-coeff-gcd 'i) '((0 2)))
((get 'termlist-coeff-gcd 'i) '((0 2) (0 6)))
((get 'termlist-coeff-gcd 'i) '((0 2) (0 6) (0 9)))

; The edited code is in generic-arithmetic-operations already
; Rerun ex-2.95.scm gives us the expected result
