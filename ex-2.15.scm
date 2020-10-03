; Here is my reasoning, let's make an interval
; And through basic arithmetic, let's see how
; the error bounds changes
; 1. r1
(define r1 (make-interval 100 102))
; 2. r1 + r1 - r1
(sub-interval (add-interval r1 r1) r1) ; => (98 104)
; 3. r1 + (r1 + r1 - r1) - r1
(sub-interval (add-interval (sub-interval (add-interval r1 r1) r1) r1) r1) ; => (96 106)
; Same goes for mul-interval then div-interval
; => Conclusion: Each repeat of r1 loosen the error bounds
; => Eva Lu Ator is right
