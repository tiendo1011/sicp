(load "list-operation.scm")

(define tree (list 1 (list 2 (list 3 4)) 5))
(enumerate-tree tree)
(count-leaves tree)
