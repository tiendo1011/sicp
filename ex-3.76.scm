(define (smooth input-stream)
  (let ((s1 (stream-car input-stream))
        (s2 (stream-car (stream-cdr input-stream))))
    (cons-stream (/ (+ s1 s2) 2) (smooth (stream-cdr input-stream)))))

(define (make-zero-crossings input-stream)
  (let ((smoothed-input-stream (smooth input-stream)))
       (stream-map sign-change-detector
                   (smoothed-input-stream)
                   (cons-stream 0 smoothed-input-stream))))
