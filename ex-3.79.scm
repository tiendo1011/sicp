(define (solve-2nd f dt yo dyo)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define dyy (stream-map f dy y))
  y)