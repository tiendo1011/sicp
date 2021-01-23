(load "stream-paradigm.scm")

(define (square x)
  (* x x))

(define (weight-fn pair)
  (+ (square (car pair)) (square (cadr pair))))

(define square-sum-stream
  (weighted-pairs
    integers
    integers
    weight-fn))

(define (tripple-filter pred stream)
  (let ((s1 (stream-car stream))
        (s2 (stream-car (stream-cdr stream)))
        (s3 (stream-car (stream-cdr (stream-cdr stream)))))
    (if (pred s1 s2 s3)
        (cons-stream
          (list s1 s2 s3 (weight-fn s1))
          (tripple-filter pred (stream-cdr (stream-cdr (stream-cdr stream)))))
        (tripple-filter pred (stream-cdr (stream-cdr (stream-cdr stream)))))))

(define tripple-way-number-stream
    (tripple-filter (lambda (s1 s2 s3) (= (weight-fn s1) (weight-fn s2) (weight-fn s3))) square-sum-stream))
(display-stream-with-limit tripple-way-number-stream 3)
