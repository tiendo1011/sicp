(define (ln2-stream n)
  (cons-stream (/ 1.0 n)
               (stream-map - (ln2-stream (+ n 1)))))

; stream 1: (ln2-stream 1)
; stream 2: (euler-transform ln2-stream)
; stream 3: (accelerated-sequence euler-transform ln2-stream)
; I guess it'll be verify fast :)
