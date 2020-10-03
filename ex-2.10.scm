(define (div-interval x y)
  (let ((up-y (upper-bound y))
        (low-y (lower-bound y)))
    (cond ((or (= up-y 0) (= low-y 0)) (error "Can't divide by zero"))
          (mul-interval
            x
            (make-interval (/ 1.0 (upper-bound y))
                           (/ 1.0 (lower-bound y)))))))
