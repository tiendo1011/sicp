(define (random-in-range low high)
  (let ((range (- high low)))
       (+ low (random range))))

(define (random-in-range-stream low high)
  (cons-stream (random-in-range low high) (random-in-range-stream low high)))

(define (test-stream P stream1 stream2)
  (cons-stream
    (P (stream-car stream1) (stream-car stream2))
    (test-stream P (stream-cdr stream1) (stream-cdr stream2))))

(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
      (/ passed (+ passed failed))
      (monte-carlo
        (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
      (next (+ passed 1) failed)
      (next passed (+ failed 1))))

(define (estimate-integral P x1 x2 y1 y2)
  (stream-map
    (lambda (p) (* p (* (- x2 x1) (- y2 y1)) 1.0)) ; without 1.0, the result would be something like 27001584/1000001
    (monte-carlo (test-stream P (random-in-range-stream x1 x2) (random-in-range-stream y1 y2)) 0 0)))

(define (P x y)
  (<= (+ (expt (- x 5) 2) (expt (- y 7) 2)) (expt 3 2)))

(stream-ref (estimate-integral P 2 8 4 10) 1000000)
