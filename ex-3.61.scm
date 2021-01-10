(load "stream.scm")
(load "power-series.scm")

(define (invert-unit-series S)
  (define X
    (cons-stream 1
                 (scale-stream
                   (mul-series (stream-cdr S) X)
                   -1)))
  X)

(define integers-inverted (invert-unit-series integers))
(define result (mul-series integers-inverted integers))
(stream-ref result 0)
(stream-ref result 1)
(stream-ref result 2)
(stream-ref result 3)
(stream-ref result 4)
