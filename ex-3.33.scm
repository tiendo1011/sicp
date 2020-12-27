(define (averager a b c)
  (let ((sum make-connector)
        (half make-connector))
    (constant 1/2 half)
    (adder a b sum)
    (multiplier sum half c)))