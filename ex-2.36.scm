(load "list-operation.scm")

(cars seqs)
(cdrs seqs)

(define s (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))

(accumulate-n + 0 s)
