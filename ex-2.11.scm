(define (mul-interval x y)
  let  (p1 (* (lower-bound x) (lower-bound y)))
  (p2 (* (lower-bound x) (upper-bound y)))
  (p3 (* (upper-bound x) (lower-bound y)))
  (p4 (* (upper-bound x) (upper-bound y)))
  (make-interval (min p1 p2 p3 p4)
                 (max p1 p2 p3 p4)))

; The nine possibilities tale
; Beautiful explanation from billthelizard:
; The suggestion is based on the result of multiplication of two numbers with the same or opposite signs.
; For each interval there are three possibilities, both signs are positive, both are negative,
; or the signs are opposite. (Note that an interval with the signs [+, -] is not allowed,
; since the lower bound would be higher than the upper bound.)
; Since there are two intervals to check, that makes nine possibilities.
; All nine possibilities are listed below.

; Lesson learned: Break problem into smaller one (atom), then apply Probability
