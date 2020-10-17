; Find all triples has 1 <= k < j < i <= n
; filter where i + j + k = s
; Each triple will product 6 permutation

(load "list-operation.scm")

(define (unique-triples n)
  (flatmap
    (lambda (i) (flatmap
                  (lambda (j) (map
                                (lambda (k) (list i j k))
                                (enumerate-interval 1 (- j 1))))
                  (enumerate-interval 1 (- i 1))))
    (enumerate-interval 1 n)))

(define (sum-triples n s)
  (flatmap
    permutations
    (filter
      (lambda (triple) (= (sum triple) s))
      (unique-triples n))))

(sum-triples 4 6)
