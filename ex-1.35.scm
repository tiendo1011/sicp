(load "fixed-point.scm")

; φ is the result of φ^2 = φ + 1 equation, devide both sides by φ
; and we have φ = 1 + 1/φ
(fixed-point (lambda (x) (+ 1 (/ 1 x))) 2.0)
