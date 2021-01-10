(load "stream.scm")

; a
(define (integrate-series input-stream)
  (div-streams input-stream integers))

(define input-stream (integers-starting-from 1))
(define integrate-series-output (integrate-series input-stream))
(stream-ref integrate-series-output 0)
(stream-ref integrate-series-output 1)
(stream-ref integrate-series-output 2)
(stream-ref integrate-series-output 3)

; b
(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

(define cosine-series
  (cons-stream 1 (integrate-series (scale-stream sine-series -1))))
(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

(define c0 (stream-ref cosine-series 0))
(define c1 (stream-ref cosine-series 1))
(define c2 (stream-ref cosine-series 2))
(define c3 (stream-ref cosine-series 3))

(define s0 (stream-ref sine-series 0))
(define s1 (stream-ref sine-series 1))
(define s2 (stream-ref sine-series 2))
(define s3 (stream-ref sine-series 3))

(+ (* c0 c0) (* s0 s0))
(+ (* c1 c1) (* s1 s1))
c1
s1
(+ (* c2 c2) (* s2 s2))
c2
s2
(+ (* c3 c3) (* s3 s3))
c3
s3
