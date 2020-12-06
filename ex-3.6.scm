(define (rand-update x)
  (+ (* 10 x) 2))

(define rand (let ((x 1))
                  (lambda (m)
                    (cond ((eq? m 'generate) (begin (set! x (rand-update x)) x))
                          ((eq? m 'reset) (lambda (new-value) (set! x new-value)))
                          (else (error "Invalid command, valid commands: generate, reset"))))))

((rand 'reset) 2)
(rand 'generate)
