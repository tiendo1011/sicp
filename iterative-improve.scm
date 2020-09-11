(define (iterative-improve good-enough? improve-guess)
  (lambda (guess) (let ((next-guess (improve-guess guess)))
                (if (good-enough? guess next-guess)
                  next-guess
                  ((iterative-improve good-enough? improve-guess) next-guess)))))
