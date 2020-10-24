(define (split outer-proc inner-proc)
  (lambda (painer n)
    ((if (= n 0)
      painter
      (let ((smaller (right-split painter (- n 1))))
           (outer-proc painter (inner-proc smaller smaller)))))))

(define right-split (split beside below))
(define up-split (split below beside))

