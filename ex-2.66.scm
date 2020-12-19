(load "binary-tree-set-operation.scm")

(define tree1 (adjoin-set 1 '()))
(define tree2 (adjoin-set 2 tree1))
(lookup 2 tree2)
