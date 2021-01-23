(load "stream-paradigm.scm")

(define (cube x)
  (* x x x))

(define (weight-fn pair)
  (+ (cube (car pair)) (cube (cadr pair))))

(define cube-sum-stream
  (weighted-pairs
    integers
    integers
    weight-fn))

(define (pair-filter pred stream)
  (let ((s1 (stream-car stream))
        (s2 (stream-car (stream-cdr stream))))
    (if (pred s1 s2)
        (cons-stream s1 (pair-filter pred (stream-cdr (stream-cdr stream))))
        (pair-filter pred (stream-cdr (stream-cdr stream))))))

(define ramanujan-number-stream
  (stream-map
    weight-fn
    (pair-filter (lambda (s1 s2) (= (weight-fn s1) (weight-fn s2))) cube-sum-stream)))
(display-stream-with-limit ramanujan-number-stream 6)
