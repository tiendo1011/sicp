(load "stream.scm")
(define partial-sums
  (cons-stream 1 (add-streams partial-sums (stream-cdr integers))))

(stream-ref partial-sums 1)
(stream-ref partial-sums 2)
(stream-ref partial-sums 3)
