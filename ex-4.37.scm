; From Ex 4.35.scm
(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
       (let ((j (an-integer-between i high)))
            (let ((k (an-integer-between j high)))
                 (require (= (+ (* i i) (* j j)) (* k k)))
                 (list i j k)))))

; From Ex 4.37.scm
(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high))
        (hsq (* high high)))
       (let ((j (an-integer-between i high)))
            (let ((ksq (+ (* i i) (* j j))))
                 (require (>= hsq ksq))
                 (let ((k (sqrt ksq)))
                      (require (integer? k))
                      (list i j k))))))

; Yes, he's correct, since the number of possibilities is down by one (an-integer-between j high)
