(load "stream.scm")
(load "base.scm")

(define (rand-update x)
  (+ x 1))

(define original-random-numbers
  (cons-stream
    1
    (stream-map rand-update original-random-numbers)))

(define (resetable-random-numbers random-numbers request-stream)
  (if (equal? (stream-car request-stream) 'generate)
      (cons-stream
        (stream-car random-numbers)
        (resetable-random-numbers (stream-cdr random-numbers) (stream-cdr request-stream)))
      (cons-stream
        (stream-car original-random-numbers)
        (resetable-random-numbers (stream-cdr original-random-numbers) (stream-cdr request-stream)))))

(define request-stream
  (cons-stream
    'generate
    (cons-stream
      'generate
      (cons-stream
        'reset
        (cons-stream
          'generate
          'generate)))))

(define rand-stream (resetable-random-numbers original-random-numbers request-stream))
(stream-ref rand-stream 0)
(stream-ref rand-stream 1)
(stream-ref rand-stream 2)
(stream-ref rand-stream 3)
