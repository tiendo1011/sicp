(load "list-operation.scm")

(fold-right / 1 (list 1 2 3))
(fold-left / 1 (list 1 2 3))
(fold-right list nil (list 1 2 3))
(fold-left list nil (list 1 2 3))
(fold-right + 1 (list 1 2 3))
(fold-left + 1 (list 1 2 3))
(fold-right max 1 (list 1 2 3))
(fold-left max 1 (list 1 2 3))

; Property: (a op b op c) = (a op (b op c))
; => It doesn't matter the order we apply op to operands
; So it's commutative property
