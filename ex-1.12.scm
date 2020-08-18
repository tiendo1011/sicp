(define (count-pascal-elements n)
  (if (= n 1)
      1
      (+ n (count-pascal-elements(- n 1)))))

(count-pascal-elements 3)
