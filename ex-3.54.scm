; mul-streams is defined in stream.scm
(load "stream.scm")
(define factorials
  (cons-stream 1 (mul-streams factorials (stream-cdr integers))))

(stream-ref factorials 3)
