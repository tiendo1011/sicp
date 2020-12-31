(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map (lambda (stream) (stream-car stream)) argstreams))
       (apply stream-map
              (cons proc (map (lambda (stream) (stream-cdr stream)) argstreams))))))
