(load "stream.scm")

(define s (cons-stream 1 (add-streams s s)))

; The stream of 1 2 4
(stream-ref s 1)
