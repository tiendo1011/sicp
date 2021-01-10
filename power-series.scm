(load "stream.scm")

(define (add-series s1 s2)
  (add-streams s1 s2))

(define (mul-series s1 s2)
  (cons-stream
    (* (stream-car s1) (stream-car s2))
    (add-streams
      (scale-stream (stream-cdr s2) (stream-car s1))
      (mul-series (stream-cdr s1) s2))))

; From ex-3.61, invert-unit-series only works with S which has contant term as 1
; Let's make invert-unit-series work with any constant term
; S*X = 1,
; (c + Sr)*X = 1,
; cX + Sr*X = 1,
; X = 1/c − 1/c*(Sr*X)
(define (invert-unit-series S)
  (let ((c (stream-car S)))
       (define X
         (cons-stream (/ 1 c)
                      (scale-stream
                        (mul-series (stream-cdr S) X)
                        (/ -1 c))))
       X))

(define (div-series s1 s2)
  (if (equal? (stream-car s2) 0)
      (error "stream constant term can't be 0")
      (mul-series s1 (invert-unit-series s2))))
