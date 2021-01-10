(load "stream.scm")

(define (expand num den radix)
  (cons-stream
    (quotient (* num radix) den)
    (expand (remainder (* num radix) den) den radix)))
; is the quotiend of (* num radix) den, where den & radix is constant

(define expand-stream (expand 1 7 10))
(stream-ref expand-stream 0) ; 1
(stream-ref expand-stream 1) ; 4
(stream-ref expand-stream 2) ; 2
(stream-ref expand-stream 3) ; 8
(stream-ref expand-stream 4) ; 5
(stream-ref expand-stream 5) ; 7
(stream-ref expand-stream 6) ; 1
(stream-ref expand-stream 7) ; 4


(define expand-stream2 (expand 3 8 10))
(stream-ref expand-stream2 0) ; 3
(stream-ref expand-stream2 1) ; 7
(stream-ref expand-stream2 2) ; 5
(stream-ref expand-stream2 3) ; 0
(stream-ref expand-stream2 4) ; 0
(stream-ref expand-stream2 5) ; 0
(stream-ref expand-stream2 6) ; 0
(stream-ref expand-stream2 7) ; 0
