(load "stream.scm")
(load "ex-3.59.scm")

(define (add-series s1 s2)
  (add-streams s1 s2))

(define (mul-series s1 s2)
  (cons-stream
    (* (stream-car s1) (stream-car s2))
    (add-streams
      (scale-stream (stream-cdr s2) (stream-car s1))
      (mul-series (stream-cdr s1) s2))))

(define squared-sin-plus-squared-cos-series
  (add-series (mul-series sine-series sine-series) (mul-series cosine-series cosine-series)))

(stream-ref squared-sin-plus-squared-cos-series 0)
(stream-ref squared-sin-plus-squared-cos-series 1)
(stream-ref squared-sin-plus-squared-cos-series 2)
(stream-ref squared-sin-plus-squared-cos-series 3)
(stream-ref squared-sin-plus-squared-cos-series 4)
